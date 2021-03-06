USE [RHPWK]
GO
/****** Object:  StoredProcedure [dbo].[P_WXSearch]    Script Date: 12/24/2018 17:37:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[P_WXSearch]
@Userid varchar(50)='',
@S_Manage_Unit nvarchar(100)='',
@T_FJType int=null,
@Stime varchar(50)='',
@Etime varchar(50)='',
@Page int =1,
@PageSize int  =10
as 
    declare @sql nvarchar(max),@Start int,@End int;
begin
    set @Start=(@Page-1)*@PageSize+1;
    set @End=@Page*@PageSize; 
    declare @usersql varchar(max);
    set   @usersql='select distinct * from F_Split((select pump_id from T_RTIOT_APP_weixin ),'','')';
    if @Userid is not null and @Userid<>''
       begin
         set   @usersql='select distinct * from F_Split((select pump_id from T_RTIOT_APP_weixin  where s_wxuserid='''+@Userid+'''),'','')';
       end  
	set @sql=N'SELECT 
	[N_ID]
	,[S_STID]
	,[S_Name]
	,convert( varchar(100), [T_FJTime] ,120) [T_FJTime]
	,[T_FJType]
	,[N_BengZSL]
	,[N_HanL]
	,[N_YuCK]
	,[N_JiangY]
	,[N_ShiC]
	,[N_PeiH]
	,[N_JianX]
	,[N_ShuSL]
	,[N_FangJL]
	,[T_UPDATEDATE]
	,[N_Manage_Unit_ID]
	,S_Manage_Unit
	,[weixinid]
	,[S_STATE]
	,[S_Remark]
	,[S_ISDEL] from(
		   SELECT 
		   [N_ID]
		  ,[S_STID]
		  ,[S_Name]
		  ,[T_FJTime]
		  ,[T_FJType]
		  ,[N_BengZSL]
		  ,[N_HanL]
		  ,[N_YuCK]
		  ,[N_JiangY]
		  ,[N_ShiC]
		  ,[N_PeiH]
		  ,[N_JianX]
		  ,[N_ShuSL]
		  ,[N_FangJL]
		  ,[T_UPDATEDATE]
		  ,[N_Manage_Unit_ID]
		  ,b. S_Manage_Unit
		  ,[weixinid]
		  ,[S_STATE]
		  ,[S_Remark]
		  ,[S_ISDEL]
		 ,ROW_NUMBER() over(order by N_ID) Num
	  FROM T_RTIOT_APP_Record a
	  left join (select S_Password,S_Manage_Unit from  T_RTIOT_APP_Manage_Unit ) b on a.[N_Manage_Unit_ID]=b.S_Password
	  where a.[S_STID] in ('+@usersql+' )';
	  if @Stime is not null and @Stime<>''
	     begin
	       set  @sql=@sql+'and [T_FJTime]>='+@Stime+'';
	     end  
      if @Etime is not null and @Etime<>''
      begin
         set @sql=@sql+'and [T_FJTime]<='+@Etime+'';
      end  
      if @S_Manage_Unit is not null and @S_Manage_Unit<>''
      begin
         set @sql=@sql+' and b.S_Manage_Unit like ''%'+@S_Manage_Unit+'%''';
      end   
	  if @T_FJType is not null and @T_FJType<>''
      begin
         set @sql=@sql+' and  T_FJType='+@T_FJType+'';
      end   
	  set @sql=@sql+') s '; 
	  set @sql=@sql+' where s.Num  between '+ cast(@Start as varchar(10))+' and '+cast(@End as varchar(10))+'';
	  print  @sql;
	  exec  sp_executesql @sql
end