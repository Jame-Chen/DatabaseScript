CREATE OR REPLACE PACKAGE PKG_SJCZ
AS
   TYPE DATE_RECORD IS RECORD --自定义类型-行（含字段及类型）
   (
      S_LOCAL varchar2(100),
      S_MANGE_ID varchar2(100),
      S_IN_MAN_FULL varchar2(100),
      S_SOURCE varchar2(100),
      S_CATEGORY_Name varchar2(100),
      T_IN_DATE varchar2(100),
      T_MANGE_TIME varchar2(100),
      S_MANGE_STATUS_Name varchar2(100),
      N_X varchar2(100),
      N_Y varchar2(100),
      TOTAL varchar2(100),
      NUM VARCHAR2(100)
     
   );

   TYPE DATE_TABLE IS TABLE OF DATE_RECORD; --自定义table类

   FUNCTION PKG_SJCZ(S_CATEGORY in varchar2 default '',S_TYPE in varchar2 default '',S_STATUS in varchar2 default '', starttime in varchar2 default '',endtime in varchar2 default '',sortid in varchar2 default '',sortdir in varchar2 default '', page in varchar2 default '1',pagesize in varchar2 default '10')
      RETURN DATE_TABLE
      PIPELINED;

END PKG_SJCZ;
/
