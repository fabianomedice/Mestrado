function [data]=importTDMS(filename,save_data)
%%% MODIFIED FROM THE ORIGINAL VESION OF convertTDMS_data from Brad
%%% Humphreys (Matlab Fileexchange)

if nargin<2
    save_data=false;
    if nargin<1
        filename=[];
    end
end

if isempty(filename)
    
    %Prompt the user for the file
    [filename,pathname]=uigetfile({'*.tdms','All Files (*.tdms)'},'Choose a TDMS File');
    if filename==0
        return
    end
    filename=fullfile(pathname,filename);
end

if ~exist(filename,'file')
    e=errordlg(sprintf('File ''%s'' not found.',filename),'File Not Found');
    uiwait(e)
    return
end




FileNameLong=filename;
[pathstr,name,ext]=fileparts(FileNameLong);
FileNameShort=sprintf('%s%s',name,ext);
FileNameNoExt=name;
FileFolder=pathstr;

disp(['Converting ' FileNameShort '...']);

fid_TDMS=fopen(FileNameLong);

if fid_TDMS==-1
    e=errordlg(sprintf('Could not open ''%s''.',FileNameLong),'File Cannot Be Opened');
    uiwait(e)
    fprintf('\n\n')
    return
%else
%    fid_tmp=fid_TDMS;
end

%if exist([FileNameLong '_index'],'file')
%    fid_TDMS_index=fopen([FileNameLong '_index']);
%    
%    if fid_TDMS_index==-1
%        e=errordlg(sprintf('Could not open ''%s''.',[FileNameLong '_index']),'File Cannot Be Opened');
%        uiwait(e)
%        fprintf('\n\n')
%        return
%    else
%        fid_tmp=fid_TDMS_index;
%    end
%end

%[SegInfo,NumOfSeg]=getSegInfo(fid_tmp);
%channelinfo=getChannelInfo(fid_tmp,SegInfo,NumOfSeg);
[SegInfo,NumOfSeg]=getSegInfo(fid_TDMS);
channelinfo=getChannelInfo(fid_TDMS,SegInfo,NumOfSeg);
ob=getData(fid_TDMS,channelinfo);
fclose(fid_TDMS);
%if fid_TDMS_index~=-1
%    fclose(fid_TDMS_index);
%end
data=organize_data(channelinfo,ob);

%manage the propertioes of the field Root
if isfield(data,'Root')
    try
    if isfield(data.Root,'Root')
        data.file_name=data.Root.Root{1};
        data.start_time=data.Root.Root{2};
        for e=3:length(data.Root.Root)
            ind=strfind(data.Root.Root{e},char(9));
            if isempty(ind)
                data.events.name{e-2}='';
                ts=data.Root.Root{e};
            else
                data.events.name{e-2}=data.Root.Root{e}(ind+1:end);
                ts=data.Root.Root{e}(1:ind-1);
            end
            try
            ind=strfind(ts,'-'); ind2=strfind(ts,':');
            if isempty(ind2), ts(ind)=':'; ind=[]; end;
                if isempty(ind) 
                    pos=strfind(data.start_time{1},' ');
                    ts=[data.start_time{1}(1:pos(1)), ts];
                end
            data.events.time_string{e-2}=ts;
            data.events.time{e-2}=datenum(ts,'dd-mm-yyyy HH:MM:SS')*24*60*60;
            catch e
            end
        end
        if isfield(data.Root,'start_time')
            data.start_time=data.Root.start_time; 
        end
        if isfield(data.Root,'start_time_relative_ms')
            data.start_time_relative_ms=data.Root.start_time_relative_ms; 
        end

    end
    catch
    end
    data=rmfield(data,'Root');
end

if save_data
    [p , n] = fileparts(FileNameLong);
    clearvars('-except','p','n','data');
    save([p filesep n '.mat'],'-struct','data');
end
end



%% getSegInfo
function [SegInfo,NumOfSeg]=getSegInfo(fid)
%Count the number of segments.  While doing the count, also include error trapping.

%Find the end of the file
fseek(fid,0,'eof');
eoff=ftell(fid);
frewind(fid);

segCnt=0;
CurrPosn=0;
LeadInByteCount=28;	%From the National Instruments web page (http://zone.ni.com/devzone/cda/tut/p/id/5696) under
%the 'Lead In' description on page 2: Counted the bytes shown in the table.
while (ftell(fid) ~= eoff)
    
    Ttag=fread(fid,1,'uint8');
    Dtag=fread(fid,1,'uint8');
    Stag=fread(fid,1,'uint8');
    mtag=fread(fid,1,'uint8');
    %if segCnt==1082
    %        disp(eoff-ftell(fid))
    %end
    if Ttag==84 && Dtag==68 && Stag==83 && (mtag==109 || mtag==104)
        %Apparently, this sequence of numbers identifies the start of a new segment.
        
        segCnt=segCnt+1;
        
        %ToC Field
        ToC=fread(fid,1,'uint32');
        
        %TDMS format version number
        vernum=fread(fid,1,'uint32');
        
        %From the National Instruments web page (http://zone.ni.com/devzone/cda/tut/p/id/5696) under the 'Lead In'
        %description on page 2:
        %The next eight bytes (64-bit unsigned integer) describe the length of the remaining segment (overall length of the
        %segment minus length of the lead in). If further segments are appended to the file, this number can be used to
        %locate the starting point of the following segment. If an application encountered a severe problem while writing
        %to a TDMS file (crash, power outage), all bytes of this integer can be 0xFF. This can only happen to the last
        %segment in a file.
        nlen=fread(fid,1,'uint64');
        if (nlen>2^63)
            break;
        else
            
            segLength=nlen;
        end
        TotalLength=segLength+LeadInByteCount;
        CurrPosn=CurrPosn+TotalLength;
        
        status=fseek(fid,CurrPosn,'bof');		%Move to the beginning position of the next segment
        if (status<0)
            warning('file glitch');
            break;
        end
    end
    
end

frewind(fid);

CurrPosn=0;
SegInfo.SegStartPosn=zeros(segCnt,1);
SegInfo.MetaStartPosn=zeros(segCnt,1);
SegInfo.DataStartPosn=zeros(segCnt,1);
SegInfo.vernum=zeros(segCnt,1);
SegInfo.DataLength=zeros(segCnt,1);
segCnt=0;
while (ftell(fid) ~= eoff)
    
    Ttag=fread(fid,1,'uint8');
    Dtag=fread(fid,1,'uint8');
    Stag=fread(fid,1,'uint8');
    mtag=fread(fid,1,'uint8');
    
    if Ttag==84 && Dtag==68 && Stag==83 && (mtag==109 || mtag==104)
        %Apparently, this sequence of numbers identifies the start of a new segment.
        
        segCnt=segCnt+1;
        
        if segCnt==1
            StartPosn=0;
        else
            StartPosn=CurrPosn;
        end
        
        %ToC Field
        ToC=fread(fid,1,'uint32');
        kTocMetaData=bitget(ToC,2);
        kTocNewObject=bitget(ToC,3);
        kTocRawData=bitget(ToC,4);
        kTocInterleavedData=bitget(ToC,6);
        kTocBigEndian=bitget(ToC,7);
        
        %         if kTocInterleavedData
        %             e=errordlg(sprintf(['Seqment %.0f has interleaved data which is not supported with this '...
        %                 'function (%s.m).'],segCnt,mfilename),'Interleaved Data Not Supported');
        %             fclose(fid);
        %             uiwait(e)
        %         end
        
        %        if kTocBigEndian
        %            e=errordlg(sprintf(['Seqment %.0f uses the big-endian data format which is not supported '...
        %                'with this function (%s.m).'],segCnt,mfilename),'Big-Endian Data Format Not Supported');
        %            fclose(fid);
        %            uiwait(e)
        %        end
        
        %TDMS format version number
        vernum=fread(fid,1,'uint32');
        if ~ismember(vernum,[4712,4713])
            e=errordlg(sprintf(['Seqment %.0f used LabView TDMS file format version %.0f which is not '...
                'supported with this function (%s.m).'],segCnt,vernum,mfilename),...
                'TDMS File Format Not Supported');
            %fclose(fid);
            uiwait(e)
        end
        
        %From the National Instruments web page (http://zone.ni.com/devzone/cda/tut/p/id/5696) under the 'Lead In'
        %description on page 2:
        %The next eight bytes (64-bit unsigned integer) describe the length of the remaining segment (overall length of the
        %segment minus length of the lead in). If further segments are appended to the file, this number can be used to
        %locate the starting point of the following segment. If an application encountered a severe problem while writing
        %to a TDMS file (crash, power outage), all bytes of this integer can be 0xFF. This can only happen to the last
        %segment in a file.
        segLength=fread(fid,1,'uint64');
        metaLength=fread(fid,1,'uint64');
        if (segLength>2^63)
            fseek(fid,0,'eof');
            flen=ftell(fid);
            segLength=flen-LeadInByteCount-TotalLength;
            TotalLength=segLength+LeadInByteCount;
        else
            TotalLength=segLength+LeadInByteCount;
            CurrPosn=CurrPosn+TotalLength;
            fseek(fid,CurrPosn,'bof');		%Move to the beginning position of the next segment
        end
        
        
        SegInfo.SegStartPosn(segCnt)=StartPosn;
        SegInfo.MetaStartPosn(segCnt)=StartPosn+LeadInByteCount;
        SegInfo.DataStartPosn(segCnt)=SegInfo.MetaStartPosn(segCnt)+metaLength;
        SegInfo.DataLength(segCnt)=segLength-metaLength;
        SegInfo.vernum(segCnt)=vernum;
        
    end
    
end
NumOfSeg=segCnt;
end


%% getChannelInfo
function index=getChannelInfo(fid,SegInfo,NumOfSeg)
%Initialize variables for the file conversion
index=struct();
objOrderList={};
for segCnt=1:NumOfSeg
    
    fseek(fid,SegInfo.SegStartPosn(segCnt)+4,'bof');
    
    %Ttag=fread(fid,1,'uint8');
    %Dtag=fread(fid,1,'uint8');
    %Stag=fread(fid,1,'uint8');
    %mtag=fread(fid,1,'uint8');
    
    %ToC Field
    ToC=fread(fid,1,'uint32');
    kTocMetaData=bitget(ToC,2);
    kTocNewObjectList=bitget(ToC,3);
    kTocRawData=bitget(ToC,4);
    %kTocInterleavedData=bitget(ToC,6);
    %kTocBigEndian=bitget(ToC,7);
    
    segVersionNum=fread(fid,1,'uint32');							%TDMS format version number for this segment
    
    segLength=fread(fid,1,'uint64');
    
    metaLength=fread(fid,1,'uint64');
    offset=0;
    %Process Meta Data
    if (kTocNewObjectList==0) %use the object list from the previous segment
        fnm=fieldnames(index);
        for kk=1:length(fnm)
            ccnt=index.(fnm{kk}).rawdatacount;
            if (ccnt>0)
                if (index.(fnm{kk}).index(ccnt)==segCnt-1)
                    ccnt=ccnt+1;
                    index.(fnm{kk}).rawdatacount=ccnt;
                    index.(fnm{kk}).datastartindex(ccnt)=SegInfo.DataStartPosn(segCnt);
                    index.(fnm{kk}).arrayDim(ccnt)=index.(fnm{kk}).arrayDim(ccnt-1);
                    index.(fnm{kk}).nValues(ccnt)=index.(fnm{kk}).nValues(ccnt-1);
                    index.(fnm{kk}).byteSize(ccnt)=index.(fnm{kk}).byteSize(ccnt-1);
                    index.(fnm{kk}).index(ccnt)=segCnt;
                    index.(fnm{kk}).rawdataoffset(ccnt)=index.(fnm{kk}).rawdataoffset(ccnt-1);
                end
            end
        end
    end
    
    if kTocMetaData
        numObjInSeg=fread(fid,1,'uint32');
        if (kTocNewObjectList)
            objOrderList=cell(numObjInSeg,1);
        end
        for q=1:numObjInSeg
            
            obLength=fread(fid,1,'uint32');								%Get the length of the objects name
            ObjName=convertToText(fread(fid,obLength,'uint8'))';	%Get the objects name
            
            if strcmp(ObjName,'/')
                long_obname='Root';
            else
                long_obname=ObjName;
                
                %Delete any apostrophes.  If the first character is a slash (forward or backward), delete it too.
                long_obname(strfind(long_obname,''''))=[];
                if strcmpi(long_obname(1),'/') || strcmpi(long_obname(1),'\')
                    long_obname(1)=[];
                end
            end
            newob=0;
            %Create object's name.  Use a generic field name to avoid issues with strings that are too long and/or
            %characters that cannot be used in MATLAB variable names.  The actual channel name is retained for the final
            %output structure.
            if exist('ObjNameList','var')
                %Check to see if the object already exists
                NameIndex=find(strcmpi({ObjNameList.LongName},long_obname)==1,1,'first');
                if isempty(NameIndex)
                    newob=1;
                    %It does not exist, so create the generic name field name
                    ObjNameList(end+1).FieldName=sprintf('Object%.0f',numel(ObjNameList)+1);
                    ObjNameList(end).LongName=long_obname;
                    NameIndex=numel(ObjNameList);
                end
            else
                %No objects exist, so create the first one using a generic name field name.
                ObjNameList.FieldName='Object1';
                ObjNameList.LongName=long_obname;
                NameIndex=1;
                newob=1;
            end
            %Assign the generic field name
            obname=ObjNameList(NameIndex).FieldName;
            
            %Create the 'index' structure
            if (~isfield(index,obname))
                index.(obname).name=obname;
                index.(obname).long_name=long_obname;
                index.(obname).rawdatacount=0;
                index.(obname).datastartindex=zeros(NumOfSeg,1);
                index.(obname).arrayDim=zeros(NumOfSeg,1);
                index.(obname).nValues=zeros(NumOfSeg,1);
                index.(obname).byteSize=zeros(NumOfSeg,1);
                index.(obname).index=zeros(NumOfSeg,1);
                index.(obname).rawdataoffset=zeros(NumOfSeg,1);
                index.(obname).multiplier=ones(NumOfSeg,1);
                index.(obname).skip=zeros(NumOfSeg,1);
            end
            if (kTocNewObjectList)
                objOrderList{q}=obname;
            else
                if ~ismember(obname,objOrderList)
                    objOrderList{end+1}=obname;
                end
            end
            %Get the raw data Index
            rawdataindex=fread(fid,1,'uint32');
            
            if rawdataindex==0
                if segCnt==0
                    e=errordlg(sprintf('Seqment %.0f within ''%s'' has ''rawdataindex'' value of 0 (%s.m).',segCnt,...
                        TDMSFileNameShort,mfilename),'Incorrect ''rawdataindex''');
                    uiwait(e)
                end
                if kTocRawData
                    if (kTocNewObjectList)
                        ccnt=index.(obname).rawdatacount+1;
                    else
                        ccnt=index.(obname).rawdatacount;
                    end
                    try
                        index.(obname).rawdatacount=ccnt;
                        index.(obname).datastartindex(ccnt)=SegInfo.DataStartPosn(segCnt);
                        index.(obname).arrayDim(ccnt)=index.(obname).arrayDim(ccnt-1);
                        index.(obname).nValues(ccnt)=index.(obname).nValues(ccnt-1);
                        index.(obname).byteSize(ccnt)=index.(obname).byteSize(ccnt-1);
                        index.(obname).index(ccnt)=segCnt;
                    catch
                        index=rmfield(index,obname);
                        return
                    end
                    
                end
            elseif rawdataindex+1==2^32
                %Objects raw data index matches previous index - no changes.  The root object will always have an
                %'FFFFFFFF' entry
                if strcmpi(index.(obname).long_name,'Root')
                    index.(obname).rawdataindex=0;
                else
                    %Need to account for the case where an object (besides the 'root') is added that has no data but reports
                    %using previous.
                    if newob
                        index.(obname).rawdataindex=0;
                    else
                        if kTocRawData
                            if (kTocNewObjectList)
                                ccnt=index.(obname).rawdatacount+1;
                            else
                                ccnt=index.(obname).rawdatacount;
                            end
                            ccnt2=max(ccnt-1,1); %heuristic solution for when ccnt=1
                            index.(obname).rawdatacount=ccnt;
                            index.(obname).datastartindex(ccnt)=SegInfo.DataStartPosn(segCnt);
                            index.(obname).arrayDim(ccnt)=index.(obname).arrayDim(ccnt2);
                            index.(obname).nValues(ccnt)=index.(obname).nValues(ccnt2);
                            index.(obname).byteSize(ccnt)=index.(obname).byteSize(ccnt2);
                            index.(obname).index(ccnt)=segCnt;
                            
                        end
                    end
                end
            else
                %Get new object information
                if (kTocNewObjectList)
                    ccnt=index.(obname).rawdatacount+1;
                else
                    ccnt=index.(obname).rawdatacount;
                    if (ccnt==0)
                        ccnt=1;
                    end
                end
                index.(obname).rawdatacount=ccnt;
                index.(obname).datastartindex(ccnt)=SegInfo.DataStartPosn(segCnt);
                %index(end).lenOfIndexInfo=fread(fid,1,'uint32');
                
                index.(obname).dataType=fread(fid,1,'uint32');
                if (index.(obname).dataType~=32)
                    index.(obname).datasize=getDataSize(index.(obname).dataType);
                end
                index.(obname).arrayDim(ccnt)=fread(fid,1,'uint32');
                index.(obname).nValues(ccnt)=fread(fid,1,'uint64');
                index.(obname).index(ccnt)=segCnt;
                if index.(obname).dataType==32
                    %Datatype is a string
                    index.(obname).byteSize(ccnt)=fread(fid,1,'uint64');
                else
                    index.(obname).byteSize(ccnt)=0;
                end
                
            end
            
            %Get the properties
            numProps=fread(fid,1,'uint32');
            if numProps>0
                
                if isfield(index.(obname),'PropertyInfo')
                    PropertyInfo=index.(obname).PropertyInfo;
                else
                    clear PropertyInfo
                end
                for p=1:numProps
                    propNameLength=fread(fid,1,'uint32');
                    switch 1
                        case 1
                            PropName=fread(fid,propNameLength,'*uint8')';
                            PropName=native2unicode(PropName,'UTF-8');
                        case 2
                            PropName=fread(fid,propNameLength,'uint8=>char')';
                        otherwise
                    end
                    propsDataType=fread(fid,1,'uint32');
                    
                    %Create property's name.  Use a generic field name to avoid issues with strings that are too long and/or
                    %characters that cannot be used in MATLAB variable names.  The actual property name is retained for the
                    %final output structure.
                    if exist('PropertyInfo','var')
                        %Check to see if the property already exists for this object.  Need to get the existing 'PropertyInfo'
                        %structure for this object.  The 'PropertyInfo' structure is not necessarily the same for every
                        %object in the data file.
                        PropIndex=find(strcmpi({PropertyInfo.Name},PropName));
                        if isempty(PropIndex)
                            %Is does not exist, so create the generic name field name
                            propExists=false;
                            PropIndex=numel(PropertyInfo)+1;
                            propsName=sprintf('Property%.0f',PropIndex);
                            PropertyInfo(PropIndex).Name=PropName;
                            PropertyInfo(PropIndex).FieldName=propsName;
                        else
                            %Assign the generic field name
                            propExists=true;
                            propsName=PropertyInfo(PropIndex).FieldName;
                        end
                    else
                        %No properties exist for this object, so create the first one using a generic name field name.
                        propExists=false;
                        PropIndex=p;
                        propsName=sprintf('Property%.0f',PropIndex);
                        PropertyInfo(PropIndex).Name=PropName;
                        PropertyInfo(PropIndex).FieldName=propsName;
                    end
                    dataExists=isfield(index.(obname),'data');
                    
                    if dataExists
                        %Get number of data samples for the object in this segment
                        nsamps=index.(obname).nsamples+1;
                    else
                        nsamps=0;
                    end
                    
                    if propsDataType==32
                        %String data type
                        PropertyInfo(PropIndex).DataType='String';
                        propsValueLength=fread(fid,1,'uint32');
                        propsValue=convertToText(fread(fid,propsValueLength,'uint8=>char'))';
                        if propExists
                            if isfield(index.(obname).(propsName),'cnt')
                                cnt=index.(obname).(propsName).cnt+1;
                            else
                                cnt=1;
                            end
                            index.(obname).(propsName).cnt=cnt;
                            index.(obname).(propsName).value{cnt}=propsValue;
                            index.(obname).(propsName).samples(cnt)=nsamps;
                        else
                            if strcmp(index.(obname).long_name,'Root')
                                %Header data
                                index.(obname).(propsName).name=index.(obname).long_name;
                                index.(obname).(propsName).value={propsValue};
                                index.(obname).(propsName).cnt=1;
                            else
                                index.(obname).(propsName).name=PropertyInfo(PropIndex).Name;
                                index.(obname).(propsName).datatype=PropertyInfo(PropIndex).DataType;
                                index.(obname).(propsName).cnt=1;
                                index.(obname).(propsName).value=cell(nsamps,1);		%Pre-allocation
                                index.(obname).(propsName).samples=zeros(nsamps,1);	%Pre-allocation
                                if iscell(propsValue)
                                    index.(obname).(propsName).value(1)=propsValue;
                                else
                                    index.(obname).(propsName).value(1)={propsValue};
                                end
                                index.(obname).(propsName).samples(1)=nsamps;
                            end
                        end
                    else
                        %Numeric data type
                        if propsDataType==68
                            PropertyInfo(PropIndex).DataType='Time';
                            %Timestamp data type
                            tsec=fread(fid,1,'uint64')/2^64+fread(fid,1,'uint64');	%time since Jan-1-1904 in seconds
                            %R. Seltzer: Not sure why '5/24' (5 hours) is subtracted from the time value.  That's how it was
                            %coded in the original function I downloaded from MATLAB Central.  But I found it to be 1 hour too
                            %much.  So, I changed it to '4/24'.
                            %propsValue=tsec/86400+695422-5/24;	%/864000 convert to days; +695422 days from Jan-0-0000 to Jan-1-1904
                            propsValue=tsec/86400+695422-4/24;	%/864000 convert to days; +695422 days from Jan-0-0000 to Jan-1-1904
                        else
                            PropertyInfo(PropIndex).DataType='Numeric';
                            matType=LV2MatlabDataType(propsDataType);
                            if strcmp(matType,'Undefined')
                                e=errordlg(sprintf('No MATLAB data type defined for a ''Property Data Type'' value of ''%.0f''.',...
                                    propsDataType),'Undefined Property Data Type');
                                uiwait(e)
                                fclose(fid);
                                return
                            end
                            if strcmp(matType,'uint8=>char')
                                propsValue=convertToText(fread(fid,1,'uint8'));
                            else
                                propsValue=fread(fid,1,matType);
                            end
                        end
                        if propExists
                            cnt=index.(obname).(propsName).cnt+1;
                            index.(obname).(propsName).cnt=cnt;
                            index.(obname).(propsName).value(cnt)=propsValue;
                            index.(obname).(propsName).samples(cnt)=nsamps;
                        else
                            index.(obname).(propsName).name=PropertyInfo(PropIndex).Name;
                            index.(obname).(propsName).datatype=PropertyInfo(PropIndex).DataType;
                            index.(obname).(propsName).cnt=1;
                            index.(obname).(propsName).value=NaN(nsamps,1);				%Pre-allocation
                            index.(obname).(propsName).samples=zeros(nsamps,1);		%Pre-allocation
                            index.(obname).(propsName).value(1)=propsValue;
                            index.(obname).(propsName).samples(1)=nsamps;
                        end
                    end
                    
                end	%'end' for the 'Property' loop
                index.(obname).PropertyInfo=PropertyInfo;
                
            end
            
        end	%'end' for the 'Objects' loop
    end
    
    %Move the offset calculation to the end to account for added channels and other optimizations
    if (kTocRawData) %only do the check if there was raw data in the segment
        offset=0;
        for kk=1:numel(objOrderList)
            obname=objOrderList{kk};
            ccnt=index.(obname).rawdatacount;
            if (ccnt>0) %&& isfield(index.(obname),'dataType') %%%%%%%% heuristic solution for the case of objects without a dataType
                index.(obname).rawdataoffset(ccnt)=offset;
                %%%%%%%% heuristic solution for the case of objects without a dataType
                    if ~isfield(index.(obname),'dataType') 
                        index.(obname).dataType=0;
                        index.(obname).datasize=0;
                    end
                if index.(obname).dataType==32
                    %Datatype is a string
                    offset=offset+index.(obname).byteSize(ccnt);
                else
                    offset=offset+index.(obname).nValues(ccnt)*index.(obname).datasize;
                end
            end
        end
        
        %Don't know why but sometimes the 'nValues' parameter is sometimes incorrect. Either the documentation was wrong or
        %someone who wrote the drivers was lazy. Seems to happen with waveform files. Check to make sure that the final
        %offset value matches the segment's size.  If it doesn't, then check if the size is a multiple of the offset.  If
        %it is, then multiply all appropriate parameters in the index structure.  If not, then generate a warning.
        if (offset~=SegInfo.DataLength(segCnt))
            %if (mod(SegInfo.DataLength(segCnt),offset)==0)
            multiplier=floor(SegInfo.DataLength(segCnt)/offset);
            for kk=1:numel(objOrderList)
                obname=objOrderList{kk};
                ccnt=index.(obname).rawdatacount;
                if (ccnt>0) &&(index.(obname).index(ccnt)==segCnt) 
                    
                    index.(obname).multiplier(ccnt)=multiplier;
                    if index.(obname).dataType==32
                        %Datatype is a string
                        index.(obname).skip(ccnt)=offset-index.(obname).byteSize(ccnt);
                    else
                        index.(obname).skip(ccnt)=offset-index.(obname).nValues(ccnt)*index.(obname).datasize;
                    end
                end
            end
            % else
            %    warning('segment %d error: offset=%d, dataLength=%d\n',segCnt,offset,SegInfo.DataLength(segCnt));
            % end
        end
    end
end
%clean up the index if it has to much data
fnm=fieldnames(index);
for kk=1:numel(fnm)
    ccnt=index.(fnm{kk}).rawdatacount+1;
    
    index.(fnm{kk}).datastartindex(ccnt:end)=[];
    index.(fnm{kk}).arrayDim(ccnt:end)=[];
    index.(fnm{kk}).nValues(ccnt:end)=[];
    index.(fnm{kk}).byteSize(ccnt:end)=[];
    index.(fnm{kk}).index(ccnt:end)=[];
    index.(fnm{kk}).rawdataoffset(ccnt:end)=[];
    index.(fnm{kk}).multiplier(ccnt:end)=[];
    index.(fnm{kk}).skip(ccnt:end)=[];
    
end
end


%% fet Data
function ob=getData(fid,index)
ob=[];
fnm=fieldnames(index);
for kk=1:length(fnm)
    id=index.(fnm{kk});
    nsamples=sum(id.nValues.*id.multiplier);
    if id.rawdatacount>0
        cname=id.name;
        ob.(cname).nsamples=0;
        if id.dataType==32
            ob.(cname).data=cell(nsamples,1);
        else
            ob.(cname).data=zeros(nsamples,1);
        end
        for rr=1:id.rawdatacount
            %Loop through each of the groups/channels and read the raw data
            fseek(fid,id.datastartindex(rr)+id.rawdataoffset(rr),'bof');
            
            
            nvals=id.nValues(rr);
            
            if nvals>0
                
                switch id.dataType
                    
                    case 32		%String
                        %From the National Instruments web page (http://zone.ni.com/devzone/cda/tut/p/id/5696) under the
                        %'Raw Data' description on page 4:
                        %String type channels are preprocessed for fast random access. All strings are concatenated to a
                        %contiguous piece of memory. The offset of the first character of each string in this contiguous piece
                        %of memory is stored to an array of unsigned 32-bit integers. This array of offset values is stored
                        %first, followed by the concatenated string values. This layout allows client applications to access
                        %any string value from anywhere in the file by repositioning the file pointer a maximum of three times
                        %and without reading any data that is not needed by the client.
                        data=cell(1,nvals*id.multiplier(rr));	%Pre-allocation
                        for mm=1:id.multiplier(rr)
                            StrOffsetArray=fread(fid,nvals,'uint32');
                            for dcnt=1:nvals
                                if dcnt==1
                                    StrLength=StrOffsetArray(dcnt);
                                else
                                    StrLength=StrOffsetArray(dcnt)-StrOffsetArray(dcnt-1);
                                end
                                data{1,dcnt+(mm-1)*nvals}=char(convertToText(fread(fid,StrLength,'uint8=>char'))');
                            end
                            if (id.multiplier(rr)>1)&&(id.skip(rr)>0)
                                fseek(fid,id.skip(rr),'cof');
                            end
                        end
                        cnt=nvals*id.multiplier(rr);
                        
                    case 68		%Timestamp
                        %data=NaN(1,nvals);	%Pre-allocation
                        data=NaN(1,nvals*id.multiplier(rr));
                        for mm=1:id.multiplier(rr)
                            dn=fread(fid,2*nvals,'uint64');
                            tsec=dn(1:2:end)/2^64+dn(2:2:end);
                            data((mm-1)*nvals+1:(mm)*nvals)=tsec/86400+695422-4/24;
                            fseek(fid,id.skip(rr),'cof');
                        end
                        %{
						for dcnt=1:nvals
							tsec=fread(fid,1,'uint64')/2^64+fread(fid,1,'uint64');   %time since Jan-1-1904 in seconds
							%R. Seltzer: Not sure why '5/24' (5 hours) is subtracted from the time value.  That's how it was
							%coded in the original function I downloaded from MATLAB Central.  But I found it to be 1 hour too
							%much.  So, I changed it to '4/24'.
							data(1,dcnt)=tsec/86400+695422-5/24;	%/864000 convert to days; +695422 days from Jan-0-0000 to Jan-1-1904
							data(1,dcnt)=tsec/86400+695422-4/24;	%/864000 convert to days; +695422 days from Jan-0-0000 to Jan-1-1904
						end
                        %}
                        cnt=nvals*id.multiplier(rr);
                        
                    otherwise	%Numeric
                        matType=LV2MatlabDataType(id.dataType);
                        if strcmp(matType,'Undefined')
                            e=errordlg(sprintf('No MATLAB data type defined for a ''Raw Data Type'' value of ''%.0f''.',...
                                id.dataType),'Undefined Raw Data Type');
                            uiwait(e)
                            fclose(fid);
                            return
                        end
                        rr=min(length(id.skip),rr);
                        if (id.skip(rr)>0)
                            ntype=sprintf('%d*%s',nvals,matType);
                            if strcmp(matType,'uint8=>char')
                                [data,cnt]=fread(fid,nvals*id.multiplier(rr),ntype,id.skip(rr));
                                data=convertToText(data);
                            else
                                [data,cnt]=fread(fid,nvals*id.multiplier(rr),ntype,id.skip(rr));
                            end
                        else
                            [data,cnt]=fread(fid,nvals*id.multiplier(rr),matType);
                        end
                end
                
                if isfield(ob.(cname),'nsamples')
                    ssamples=ob.(cname).nsamples;
                else
                    ssamples=0;
                end
                if (cnt>0)
                    ob.(cname).data(ssamples+1:ssamples+cnt,1)=data;
                    ob.(cname).nsamples=ssamples+cnt;
                end
            end
        end
        
    end
    
end
end

%% organize_data
function data=organize_data(channelinfo,ob)
fc=fieldnames(channelinfo);
data=[];
rc={'.','_';'/','.';'%','perc';' ','_';'(','';')','';'-','';':','to';'1','one';char(10),''};
for i=1:length(fc)
    xxx=channelinfo.(fc{i}).long_name;
    for r=1:size(rc,1)
    xxx=strrep(xxx,rc{r,1},rc{r,2});
    end
    datafound=isfield(ob,fc{i});
    if datafound
        eval(['data.' xxx '.val=ob.' fc{i} '.data;']);
    end
    count =1;
    npn={};
    while count>0
        np=['Property' num2str(count)];
        if isfield(channelinfo.(fc{i}),np) & (isempty(findstr(xxx,'.')) | datafound)
            if ~strcmp(channelinfo.(fc{i}).(np).name,'NI_ArrayColumn')
                npv=channelinfo.(fc{i}).(np).value;
                npn{count}=channelinfo.(fc{i}).(np).name;
                if strcmpi(npn{count},'units')
                    npv=npv{1};
                end
                sss=['data.' xxx '.' channelinfo.(fc{i}).(np).name ];
                if count ==1
                    eval([sss '= npv;']);
                else
                    switch sum(strcmp(npn(1:count-1),npn(end)))
                        case 0
                            eval([sss '= npv;']);
                        case 1
                            eval([sss '={' sss ' npv};']);
                        otherwise
                            eval([sss '=[' sss ' npv];']);
                    end
                end
            end
            count=count+1;
        else
            count=0;
        end
    end
end
end

%% getDataSize
function sz=getDataSize(LVType)
switch(LVType)
    case 0
        sz=0;
    case {1,5,33}
        sz=1;
    case 68
        sz=16;
    case {8,10}
        sz=8;
    case {3,7,9}
        sz=4;
    case {2,6}
        sz=2;
    case 32
        e=errordlg('Do not call the getDataSize function for strings.  Their size is written in the data file','Error');
        uiwait(e)
        sz=NaN;
    case 11
        sz=10;
end
end

%% LV2MatlabDataType
function matType=LV2MatlabDataType(LVType)
%Cross Refernce Labview TDMS Data type to MATLAB
switch LVType
    case 0   %tdsTypeVoid
        matType='';
    case 1   %tdsTypeI8
        matType='int8';
    case 2   %tdsTypeI16
        matType='int16';
    case 3   %tdsTypeI32
        matType='int32';
    case 4   %tdsTypeI64
        matType='int64';
    case 5   %tdsTypeU8
        matType='uint8';
    case 6   %tdsTypeU16
        matType='uint16';
    case 7   %tdsTypeU32
        matType='uint32';
    case 8   %tdsTypeU64
        matType='uint64';
    case 9  %tdsTypeSingleFloat
        matType='single';
    case 10  %tdsTypeDoubleFloat
        matType='double';
    case 11  %tdsTypeExtendedFloat
        matType='10*char';
    case 25 %tdsTypeSingleFloat with units
        matType='Undefined';
    case 26 %tdsTypeDoubleFloat with units
        matType='Undefined';
    case 27 %tdsTypeextendedFloat with units
        matType='Undefined';
    case 32  %tdsTypeString
        matType='uint8=>char';
    case 33  %tdsTypeBoolean
        matType='bit1';
    case 68  %tdsTypeTimeStamp
        matType='2*int64';
    otherwise
        matType='Undefined';
end

end

%% convertToText
function text=convertToText(bytes)
%Convert numeric bytes to the character encoding localy set in MATLAB (TDMS uses UTF-8)

text=native2unicode(bytes,'UTF-8');
end