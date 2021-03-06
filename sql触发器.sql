USE [QPSSYH]
GO
/****** Object:  Trigger [dbo].[TR_T_RTRPT_PUMP_HIS_to_T_RTRPT_PUMP_HIS_HIS]    Script Date: 12/24/2018 15:01:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		wkb
-- Create date: 2015-01-30
-- Description:	触发到中间表
-- =============================================
ALTER TRIGGER [dbo].[TR_T_RTRPT_PUMP_HIS_to_T_RTRPT_PUMP_HIS_HIS]
 ON [dbo].[T_RTRPT_PUMP_HIS]
FOR INSERT,UPDATE
AS 
BEGIN
   DECLARE @N_ID                  decimal(10)
  DECLARE @S_DRAI_PUMP_ID        NVARCHAR(32)
  DECLARE @S_SNAME               NVARCHAR(38)
  DECLARE @N_DRAI_PUMP_TYPE      decimal(10,2)
  DECLARE @N_DRAI_PUMP_TYPE_FEAT decimal(10,2)
  DECLARE @T_STIME               DATEtime
  DECLARE @N_LIULIANG            decimal(10,2)
  DECLARE @N_YULIANG             decimal(10,2)
  DECLARE @N_SHUIWEI             decimal(10,2)
  DECLARE @N_TAISHU              decimal(10,2)
  DECLARE @N_KAIJITAISHU         decimal(10,2)
  DECLARE @N_YEWEI               decimal(10,2)
  DECLARE @N_WAIYEWEI            decimal(10,1)
  DECLARE @N_RUNNING             decimal(2)
  DECLARE @S_PUMPSTATUS          VARCHAR(38)
  DECLARE @COD                   decimal(12,6)
  DECLARE @PH                    decimal(12,6)
  DECLARE @BOD                   decimal(12,6)
  DECLARE @NH3N                  decimal(12,6)
  DECLARE @TP                    decimal(12,6)
  DECLARE @TN                    decimal(12,6)
  DECLARE @TOC                   decimal(12,6)
  DECLARE @SS                    decimal(12,6)
  DECLARE @LJLL					 decimal(12,6)
  DECLARE @CCKG					 decimal(12,6)
  DECLARE @SSLL1				 decimal(12,6)
  DECLARE @SSLL2				 decimal(12,6)
  DECLARE @SSLL3				 decimal(12,6)
  DECLARE @SSLL4				 decimal(12,6)
  DECLARE @SSLL5				 decimal(12,6)
  DECLARE @SSLL6				 decimal(12,6)
  DECLARE @SSLL7				 decimal(12,6)
  DECLARE @SSLL8				 decimal(12,6)
  DECLARE @SSLL9				 decimal(12,6)
  DECLARE @SSLL10				 decimal(12,6)
  DECLARE @SSLL11				 decimal(12,6)
  DECLARE @SSLL12				 decimal(12,6)
  DECLARE @S_LLJS				 decimal(12,6)
  DECLARE @BZSSLL				 decimal(12,6)


	   
	    DECLARE CUR1 CURSOR FOR 
		SELECT 
	N_ID,
S_DRAI_PUMP_ID,
S_SNAME,
N_DRAI_PUMP_TYPE,
N_DRAI_PUMP_TYPE_FEAT,
T_STIME,
N_LIULIANG,
N_YULIANG,
N_SHUIWEI,
N_TAISHU,
N_KAIJITAISHU,
N_YEWEI,
N_WAIYEWEI,
N_RUNNING,
S_PUMPSTATUS,
COD,
PH,
BOD,
NH3N,
TP,
TN,
TOC,
SS,
LJLL
,CCKG
,SSLL1
,SSLL2
,SSLL3
,SSLL4
,SSLL5
,SSLL6
,SSLL7
,SSLL8
,SSLL9
,SSLL10
,SSLL11
,SSLL12
,S_LLJS
,BZSSLL
  FROM INSERTED 
		
	   OPEN CUR1
	
	   FETCH NEXT FROM CUR1 INTO 
@N_ID,
@S_DRAI_PUMP_ID,
@S_SNAME,
@N_DRAI_PUMP_TYPE,
@N_DRAI_PUMP_TYPE_FEAT,
@T_STIME,
@N_LIULIANG,
@N_YULIANG,
@N_SHUIWEI,
@N_TAISHU,
@N_KAIJITAISHU,
@N_YEWEI,
@N_WAIYEWEI,
@N_RUNNING,
@S_PUMPSTATUS,
@COD,
@PH,
@BOD,
@NH3N,
@TP,
@TN,
@TOC,
@SS,
@LJLL
,@CCKG
,@SSLL1
,@SSLL2
,@SSLL3
,@SSLL4
,@SSLL5
,@SSLL6
,@SSLL7
,@SSLL8
,@SSLL9
,@SSLL10
,@SSLL11
,@SSLL12
,@S_LLJS
,@BZSSLL
		
		WHILE @@FETCH_STATUS =0
	    BEGIN
	
--sw 水位
IF not EXISTS (select 1 from (
SELECT S_DRAI_PUMP_ID,max(T_STIME) T_STIME  FROM T_RTRPT_PUMP_HIS_HIS group by S_DRAI_PUMP_ID 
) s  WHERE s.S_DRAI_PUMP_ID=@S_DRAI_PUMP_ID AND T_STIME=@T_STIME)
BEGIN
INSERT INTO T_RTRPT_PUMP_HIS_HIS(
	
S_DRAI_PUMP_ID,
S_SNAME,
N_DRAI_PUMP_TYPE,
N_DRAI_PUMP_TYPE_FEAT,
T_STIME,
N_LIULIANG,
N_YULIANG,
N_SHUIWEI,
N_TAISHU,
N_KAIJITAISHU,
N_YEWEI,
N_WAIYEWEI,
N_RUNNING,
S_PUMPSTATUS,
COD,
PH,
BOD,
NH3N,
TP,
TN,
TOC,
SS,
LJLL
,CCKG
,SSLL1
,SSLL2
,SSLL3
,SSLL4
,SSLL5
,SSLL6
,SSLL7
,SSLL8
,SSLL9
,SSLL10
,SSLL11
,SSLL12
,S_LLJS
,BZSSLL
				) VALUES (
@S_DRAI_PUMP_ID,
@S_SNAME,
@N_DRAI_PUMP_TYPE,
@N_DRAI_PUMP_TYPE_FEAT,
@T_STIME,
@N_LIULIANG,
@N_YULIANG,
@N_SHUIWEI,
@N_TAISHU,
@N_KAIJITAISHU,
@N_YEWEI,
@N_WAIYEWEI,
@N_RUNNING,
@S_PUMPSTATUS,
@COD,
@PH,
@BOD,
@NH3N,
@TP,
@TN,
@TOC,
@SS,
@LJLL
,@CCKG
,@SSLL1
,@SSLL2
,@SSLL3
,@SSLL4
,@SSLL5
,@SSLL6
,@SSLL7
,@SSLL8
,@SSLL9
,@SSLL10
,@SSLL11
,@SSLL12
,@S_LLJS
,@BZSSLL
				)			
			END
		
        

          
           FETCH NEXT FROM CUR1 INTO 
		   @N_ID,
@S_DRAI_PUMP_ID,
@S_SNAME,
@N_DRAI_PUMP_TYPE,
@N_DRAI_PUMP_TYPE_FEAT,
@T_STIME,
@N_LIULIANG,
@N_YULIANG,
@N_SHUIWEI,
@N_TAISHU,
@N_KAIJITAISHU,
@N_YEWEI,
@N_WAIYEWEI,
@N_RUNNING,
@S_PUMPSTATUS,
@COD,
@PH,
@BOD,
@NH3N,
@TP,
@TN,
@TOC,
@SS,
@LJLL
,@CCKG
,@SSLL1
,@SSLL2
,@SSLL3
,@SSLL4
,@SSLL5
,@SSLL6
,@SSLL7
,@SSLL8
,@SSLL9
,@SSLL10
,@SSLL11
,@SSLL12
,@S_LLJS
,@BZSSLL

			--insert into test(name,[time]) values('----触发器结束-------',getdate());
		END
	  --  insert into test(name,[time]) values('----触发器结束-------',getdate());
		CLOSE CUR1
        DEALLOCATE CUR1
END
