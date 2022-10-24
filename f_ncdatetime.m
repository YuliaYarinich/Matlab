function [arr_double arr_char arr_datetime arr_init units] = f_ncdatetime(filename,tbeg,tdur,tstep, fchar,fdatetime)    
    
    % NCDATETIME reads time array from netcdf file and converts it from format 'hours/minutes/seconds since...' 
    % to user-friendly format in double, character and datetime versions.
    %
    % *************************** O U T P U T ******************************
    % 
    % arr_double   - N x 6 double array of [Year Month Day Hour Minute Second] value in 1 row
    % arr_char     - N x M char array of nc-time variable with manual format 'fchar'
    % arr_datetime - N x 1 datetime array of nc-time variable with manual format 'fdatetime'
    % arr_init     - N x 1 double array of initial datetime value from nc-file
    % units        - character array of units from attributes in nc-file
    %                'hours/ minutes/ seconds since...'
    %    where N   - length of netcdf time array from 'tbeg' with duration 'tdur' and with step 'tstep'
    %          M   - length of users character array 'fchar'
    %
    % **************************** I N P U T ******************************
    %
    % filename    - character array of filename. Example: 'D:\ERA5-data\ERA-5_sfc_2017_07.nc'
    %
    %  SPECIAL: if you want to read the whole file, set tbeg=1, tdur=Inf, tstep=1 as in the example below
    % tbeg      - intex of time from which you want to start reading file
    % tdur      - duration of period for reading file
    % tstep     - step between nearby time indices you want to read
    %
    % fchar     - manual inputted format of character time array 'arr_char'
    % fdatetime - manual inputted format of datetime array 'arr_datetime'
    %     NOTE that months and minutes have different latter case in format
    %     specification for character and for datetime arrays.
    %        char:     mm - months, MM - minutes
    %        datetime: MM - months, mm - minutes
    %     Details: 
    %        https://www.mathworks.com/help/matlab/matlab_prog/set-display-format-of-date-and-time-arrays.html
    %        https://ch.mathworks.com/help/matlab/ref/datestr.html
    %
    % USING FUNCTION:
    % EXAMPLE: [a b c d e] = f_ncdatetime(path.filename, 1,Inf,1, 'yyyy-mm-dd HH-MM-ss','yyyy-MM-dd HH:mm:ss') 
    %                       uses all the data from file
    %
    % Author: Yulia Yarinich
    % email: julia.yarinich@yandex.ru
    % Date: 2021-2022
    % __________________________
    
    % READING ATTRIBUTES (example: 'hours since 1979-01-01 00:00:00')
    atts.units = ncreadatt(filename,'time','units'); 
    % According to time units which were read setting time factor and time units
    if (contains(atts.units,'days'))
        disp(['    f_ncdatetime output of time units: days'])
        atts.time_factor = 86400;
        atts.time_units = 'days';
    elseif (contains(atts.units,'hours'))
        disp(['    f_ncdatetime output of time units: hours'])
        atts.time_factor = 3600;
        atts.time_units = 'hours';
    elseif (contains(atts.units,'minutes'))
        disp('    f_ncdatetime output of time units: minutes')
        atts.time_factor = 60;
        atts.time_units = 'minutes';
    elseif (contains(atts.units,'seconds'))
        disp('    f_ncdatetime output of time units: seconds')
        atts.time_factor = 1;
        atts.time_units = 'seconds';
    else 
        disp(['    ERROR: no time format. Add time format to f_ncdatetime'])
        exit 
    end
     
    % READING TIME FROM NC FILE
    arr_init = double(ncread(filename, 'time', tbeg, tdur, tstep));  % Reading time array from nc fime with name 'filename'
    arr_init = arr_init * atts.time_factor;                          % Make seconds from hours/minutes
    units = ncreadatt(filename,'time','units');                      % Reading units attribute
    tmp = erase(units, [atts.time_units ' since ']);                 % Extracting date from units
    tmp = strrep(tmp,'T',' ');
    % Formatting arrays
    arr_char = datestr(datetime(arr_init,'ConvertFrom','epochtime','Epoch',tmp));
    arr_datetime = datetime(arr_init,'ConvertFrom','epochtime','Epoch',tmp);
    arr_double = [str2num(datestr(arr_char,'yyyy')) str2num(datestr(arr_char,'mm')) ...
                 str2num(datestr(arr_char,'dd')) str2num(datestr(arr_char,'HH')) ...
                 str2num(datestr(arr_char,'MM')) str2num(datestr(arr_char,'ss'))];
    % Final formatting according to input info 
    arr_char = datestr(arr_char,fchar);
    arr_datetime = datetime(arr_datetime,'Format',fdatetime);
    
end