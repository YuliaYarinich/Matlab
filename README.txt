    NCDATETIME reads time array from netcdf file and converts it from format 'days/hours/minutes/seconds since...' 
    to user-friendly format in double, character and datetime versions.
    
    *************************** O U T P U T ******************************
     
    arr_double   - N x 6 double array of [Year Month Day Hour Minute Second] value in 1 row
    arr_char     - N x M char array of nc-time variable with manual format 'fchar'
    arr_datetime - N x 1 datetime array of nc-time variable with manual format 'fdatetime'
    arr_init     - N x 1 double array of initial datetime value from nc-file
    units        - character array of units from attributes in nc-file
                   'days/hours/ minutes/ seconds since...'
       where N   - length of netcdf time array from 'tbeg' with duration 'tdur' and with step 'tstep'
             M   - length of users character array 'fchar'
    
    **************************** I N P U T ******************************
    
    filename    - character array of filename. Example: 'D:\ERA5-data\ERA-5_sfc_2017_07.nc'
    
     SPECIAL: if you want to read the whole file, set tbeg=1, tdur=Inf, tstep=1 as in the example below
    tbeg      - intex of time from which you want to start reading file
    tdur      - duration of period for reading file
    tstep     - step between nearby time indices you want to read
    
    fchar     - manual inputted format of character time array 'arr_char'
    fdatetime - manual inputted format of datetime array 'arr_datetime'
        NOTE that months and minutes have different latter case in format
        specification for character and for datetime arrays.
           char:     mm - months, MM - minutes
           datetime: MM - months, mm - minutes
        Details: 
           https://www.mathworks.com/help/matlab/matlab_prog/set-display-format-of-date-and-time-arrays.html
           https://ch.mathworks.com/help/matlab/ref/datestr.html
   
    USING FUNCTION:
    EXAMPLE: [a b c d e] = f_ncdatetime(path.filename, 1,Inf,1, 'yyyy-mm-dd HH-MM-ss','yyyy-MM-dd HH:mm:ss') 
                           uses all the data from file
    
    Author: Yulia Yarinich
    email: julia.yarinich@yandex.ru
    Date: 2021-2022
    __________________________
