CREATE OR REPLACE PACKAGE BODY PKG_SJCZ

AS
   FUNCTION PKG_SJCZ(S_CATEGORY in varchar2 default '',S_TYPE in varchar2 default '',S_STATUS in varchar2 default '', starttime in varchar2 default '',endtime in varchar2 default '',sortid in varchar2 default '',sortdir in varchar2 default '', page in varchar2 default '1',pagesize in varchar2 default '10')
      RETURN DATE_TABLE
      PIPELINED
   IS
       V_CATEGORY varchar2(100);
       V_TYPE varchar2(100);
       V_STATUS varchar2(100);
       v_starttime varchar2(100);
       v_endtime varchar2(100);
       v_sortid varchar2(100);
       v_sortdir varchar2(100);
       v_sql varchar2(4000);
       v_totalsql varchar2(1000);
       v_page number(10);
       v_pagesize number(10);
       v_start number(10);
       v_end number(10);
       cur_sys sys_refcursor;
       cur_cfg S_SJCZ%rowtype;
       RESULT_CFG  DATE_RECORD;

   BEGIN
       V_CATEGORY:=S_CATEGORY;
       V_TYPE:= S_TYPE;
       V_STATUS:=S_STATUS;
       v_starttime:=starttime;
       v_endtime:=endtime;
       v_sortid:=sortid;
       v_sortdir:=sortdir;
       v_page:=to_number(page);
       v_pagesize:=to_number(pagesize);
       v_start:=(v_page-1)*v_pagesize+1;
       v_end:=v_page*v_pagesize;
       
       v_totalsql:='select count(1)  from V_PATROL_MANAGEMENT_SJCZ where  S_DELETE=1  ';
        if  V_CATEGORY is not null then
        v_totalsql:=v_totalsql||' and S_CATEGORY='''||V_CATEGORY||'''';
        end if;
        if  V_TYPE is not null then
         v_totalsql:=v_totalsql||' and S_TYPE='''||V_TYPE||'''';--统计总数
        end if;
        
        if  V_STATUS is not null then
         v_totalsql:=v_totalsql||' and S_STATUS='''||V_STATUS||'''';
        end if;
         if  v_starttime is not null then
        v_totalsql:=v_totalsql||' and T_IN_DATE >=to_date('''||v_starttime||''',''yyyy-mm-dd hh24:mi:ss'')';
        end if;
         if  v_endtime is not null then
        v_totalsql:=v_totalsql||' and T_IN_DATE <=to_date('''||v_endtime||''',''yyyy-mm-dd hh24:mi:ss'')';
        end if;
       v_sql:='select S_LOCAL,S_MANGE_ID,S_IN_MAN_FULL,S_SOURCE,S_CATEGORY_Name,T_IN_DATE,T_MANGE_TIME,S_MANGE_STATUS_Name,N_X,N_Y,TOTAL,('||v_start||'-1+rownum) NUM from (
               select S_LOCAL,S_MANGE_ID,
               S_IN_MAN_FULL,
               S_SOURCE,
               (select s_value from t_dict where s_code=''W10026'' and s_correspond=V_PATROL_MANAGEMENT_SJCZ.S_CATEGORY)||''-''||(select s_value from t_dict where s_pcode=V_PATROL_MANAGEMENT_SJCZ.S_CATEGORY and s_correspond=V_PATROL_MANAGEMENT_SJCZ.S_TYPE) S_CATEGORY_Name,
               to_char(T_IN_DATE,''yyyy-mm-dd hh24:mi'') T_IN_DATE,
               to_char(T_MANGE_TIME,''yyyy-mm-dd hh24:mi'') T_MANGE_TIME,
               (select s_value from t_dict where s_code=''W10065'' and s_correspond=V_PATROL_MANAGEMENT_SJCZ.S_STATUS) S_MANGE_STATUS_Name,
               N_X,
               N_Y,
               ('||v_totalsql||') total,
               rownum RNUM 
               from V_PATROL_MANAGEMENT_SJCZ 
               where  S_DELETE=1';
 

    if  V_CATEGORY is not null then
    v_sql:=v_sql||' and S_CATEGORY='''||V_CATEGORY||'''';
    end if;
    if  V_TYPE is not null then
     v_sql:=v_sql||' and S_TYPE='''||V_TYPE||'''';--统计总数
    end if;
        
    if  V_STATUS is not null then
     v_sql:=v_sql||' and S_STATUS='''||V_STATUS||'''';
    end if;
     if  v_starttime is not null then
    v_sql:=v_sql||' and T_IN_DATE >=to_date('''||v_starttime||''',''yyyy-mm-dd hh24:mi:ss'')';
    end if;
    
     if  v_endtime is not null then
    v_sql:=v_sql||' and T_IN_DATE <=to_date('''||v_endtime||''',''yyyy-mm-dd hh24:mi:ss'')';
    end if;
    if  v_sortdir is not null and v_sortid is not null then
     v_sql:=v_sql||'  order by '||v_sortid||' '|| v_sortdir||' ';
    else
     v_sql:=v_sql||'  order by t_in_date desc';
    end if;
    
    v_sql:=v_sql||' ) t  WHERE RNUM between '||v_start||' and '||v_end||' ';
     dbms_output.put_line(v_sql);

   
     open cur_sys for v_sql;

      LOOP

         fetch cur_sys into cur_cfg;
         exit when cur_sys%notfound;
         RESULT_CFG.S_LOCAL := cur_cfg.S_LOCAL;
         RESULT_CFG.S_MANGE_ID := cur_cfg.S_MANGE_ID;
         RESULT_CFG.S_IN_MAN_FULL := cur_cfg.S_IN_MAN_FULL;
         RESULT_CFG.S_SOURCE:=cur_cfg.S_SOURCE;
         RESULT_CFG.S_CATEGORY_Name := cur_cfg.S_CATEGORY_Name;
         RESULT_CFG.T_IN_DATE :=cur_cfg.T_IN_DATE;
         RESULT_CFG.T_MANGE_TIME :=cur_cfg.T_MANGE_TIME;
         RESULT_CFG.S_MANGE_STATUS_Name:=cur_cfg.S_MANGE_STATUS_Name;
         RESULT_CFG.N_X :=cur_cfg.N_X;
         RESULT_CFG.N_Y :=cur_cfg.N_Y;
         RESULT_CFG.TOTAL:=cur_cfg.TOTAL;
         RESULT_CFG.NUM:=cur_cfg.NUM;
       PIPE ROW (RESULT_CFG);
      END LOOP;

      close cur_sys;

   END;
END PKG_SJCZ;
/
