  WITH BI AS
(
--This CTE is joining an employee's card number with their employee number
  SELECT BADGE_C.CARDNO, BADGE_V.BADGE_EMPLOYEE_NO
  FROM BADGE_V 
  INNER join BADGE_C ON BADGE_C.ID = BADGE_V.ID
),
empScans as 
(
--This CTE is primarily selecting the imporant columns for the report.
  select evnt_dat, location, cast(cardno as varchar(5)) as CARDNO, fname, lname, PANEL_DESCRP, CARDSTATUS.DESCRP as statDescrp
  from EV_LOG
  inner join CARDSTATUS ON CARDSTATUS.STATUS = EV_LOG.STAT_COD
  where (EVNT_DAT is not null)
  group by CARDNO, LOCATION, fname, lname, EVNT_DAT, PANEL_DESCRP, CARDSTATUS.DESCRP
)
--This main query is tying everything together
  select * from empScans
  inner join BI on BI.cardno = empScans.CARDNO
  where (evnt_dat >  '20190701 06:00:00') --Start Date
  and (evnt_dat < '20190708 19:00:00') --End Date
  and (BADGE_EMPLOYEE_NO ='78796')                                 
  order by evnt_dat desc
