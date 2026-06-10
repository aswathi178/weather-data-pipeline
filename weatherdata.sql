CREATE OR REPLACE DATABASE WEATHER1_DB;
USE DATABASE WEATHER1_DB;

CREATE TABLE WEATHER_DATA(
    data variant
);

Create or replace stage my_s3_stage
URL = 's3://weather-project-s3/'
CREDENTIALS = (
    AWS_KEY_ID = ''AKIA3MTEIHRGLBIAWHLV''
    AWS_SECRET_KEY = ''xN51wYftPJUt/f96yArzIkKUQQLpfxiES+Xau8eY''
);



LIST @my_s3_stage;

COPY INTO WEATHER_DATA
FROM @my_s3_stage
FILE_FORMAT = (TYPE = 'JSON');

SELECT * FROM WEATHER_DATA;

SELECT 
    data:city::String as city,
    data:temperature.S::FLOAT as temp,
    data:humidity.S::String as humidity,
    data:timestamp.S::STRING AS report_time
FROM WEATHER_DATA;
SELECT * FROM TABLE(INFORMATION_SCHEMA.COPY_HISTORY(
    TABLE_NAME=>'WEATHER_DATA',
    START_TIME=>DATEADD(HOURS,-1,CURRENT_TIMESTAMP())
));

create or replace pipe my_pipe
AUTO_INGEST = False
as
copy into weather_data
from @my_s3_stage
file_format = (TYPE='JSON');

ALTER PIPE my_pipe REFRESH;

LIST @my_s3_stage;

SELECT DATA FROM WEATHER_DATA LIMIT 5;