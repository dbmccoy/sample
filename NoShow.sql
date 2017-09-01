--Ambulatory Visits for last month taken from
--Epic-delivered Crystal PT_VISIT_COUNT_FLX_PARAM For SHV and MON w Payor Plan_by dept by dept specialty


SET NOCOUNT ON
SET ANSI_WARNINGS OFF


declare @StartDate datetime
declare @EndDate datetime
              
set @StartDate = '8/1/2017'--DATEADD(m,-1,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)) 
set @EndDate =  '9/1/2017' --DATEADD(d,-1,DATEADD(mm, DATEDIFF(m,0,GETDATE()),1)) 

Select distinct enc.SERV_AREA_ID 
	   , (CASE WHEN csn1.appt_status_c = 4 THEN 1 ELSE 0 END) + (CASE WHEN csn1.appt_status_c = 4 THEN 1 ELSE 0 END) 'NoShowCount'
	   , CASE WHEN enc.appt_status_c IN (2,6,5) THEN 'Completed'
			  WHEN enc.appt_status_c = 4 THEN 'No Show'
			  WHEN enc.appt_status_c = 1 THEN 'Scheduled'
			  WHEN enc.appt_status_c = 3 THEN 'Canceled'
	     END AS 'Status'
	   --, apt.appt_made_date
	   , DATEPART(HOUR,apt.appt_dttm) 'ApptHour'
	   , DATENAME(WEEKDAY,apt.appt_dttm) 'DayOfWeek'
       , MONTH(enc.CONTACT_DATE) 'ApptMonth' 
	   , enc.contact_date 'ApptDate'
	   , CASE WHEN enc.pcp_prov_id = enc.visit_prov_id THEN 1 ELSE 0 END AS 'PCP'
	   , CASE WHEN apt.referring_prov_id IS NOT NULL THEN 1 ELSE 0 END AS 'Referral'
	   , DATEDIFF(d,apt.appt_made_date,apt.appt_dttm) 'LeadDays'
	   , enc.DEPARTMENT_ID
	   , COALESCE(har.hsp_account_id, enc.hsp_account_id) AS 'har'
	   , enc.pat_enc_csn_id 'csn'
	   , csn1.pat_enc_csn_id 'PastCSN1'
	   , csn2.pat_enc_csn_id 'PastCSN2'
	   , CASE WHEN apt.change_cnt > 0 THEN 1 ELSE 0 END AS ApptChanged
	   , CASE WHEN (SELECT TOP 1 apt.resched_appt_csn_id 
					FROM v_sched_appt apt
					WHERE apt.resched_appt_csn_id = enc.pat_enc_csn_id) IS NOT NULL
		 THEN 1 ELSE 0 END AS 'isReschedule'
	   , DATEDIFF(year,patient.birth_date,enc.contact_date) 'Age'
	   , COALESCE(zc_language.name, 'English') 'Language'
	   , patient.sex_c 'Sex'
	   , zc_patient_race.name 'Race'
	   , CASE WHEN zc_ethnic_bkgrnd.internal_id = 1 THEN 1 ELSE 0 END AS 'Hispanic'
	   , CASE WHEN patient.marital_status_c IN (2,101) THEN 1 ELSE 0 END AS 'Married'
	   , zc_religion.name 'Religion'
	   , CASE WHEN zc_smoking_tob_use.internal_id IN (1,2,3,9,10) THEN 1 ELSE 0 END AS 'Smoker'
	   , COALESCE(enc.BMI,csn1.BMI,csn2.BMI) 'BMI'
	   --, patient_2.is_adopted_yn 'Adopted'
	   , enc.pat_id
	   , CLARITY_DEP.DEPARTMENT_NAME
	   , clarity_dep.specialty 'DepSpecialty'
	   /*
	   , CASE WHEN zfc.name IN ('Blue Cross','Commercial','Medicare Advantage','Prisoner'
							,'Third Party Liability','Worker''s Comp')
		       THEN 'Commercial'
		   WHEN zfc.name IN ('Medicaid','Medicaid Managed Care','Out of State Medicaid')
		       THEN 'Medicaid'
		   WHEN zfc.name IN ('Self-pay','MAP')
		       THEN 'Self-pay'
		   WHEN zfc.name = 'Free Care'
		       THEN 'Free Care'
		   WHEN zfc.name = 'Medicare'
		       THEN 'Medicare'
		   ELSE zfc.name + 'NULL'
	   END AS FinClass

	   , zfc.name as FinClass2
	   , clarity_epm.payor_name payor
       */
FROM     PAT_ENC AS enc 
       LEFT OUTER JOIN CLARITY_SER ON enc.VISIT_PROV_ID = CLARITY_SER.prov_id
       LEFT OUTER JOIN CLARITY_DEP ON enc.DEPARTMENT_ID = CLARITY_DEP.DEPARTMENT_ID 
       LEFT OUTER JOIN HSP_ACCOUNT har ON enc.HSP_ACCOUNT_ID = har.HSP_ACCOUNT_ID 
              left outer join ZC_FIN_CLASS zfc
                     on har.ACCT_FIN_CLASS_C=zfc.FIN_CLASS_C
	   LEFT OUTER JOIN clarity_epm epm ON enc.VISIT_EPM_ID = epm.PAYOR_ID
       LEFT OUTER JOIN CLARITY_LOC ON CLARITY_DEP.REV_LOC_ID = CLARITY_LOC.LOC_ID 
       LEFT OUTER JOIN CLARITY_SER_SPEC ON CLARITY_SER.PROV_ID = CLARITY_SER_SPEC.PROV_ID 
       LEFT OUTER JOIN ZC_SPECIALTY ON CLARITY_SER_SPEC.SPECIALTY_C = ZC_SPECIALTY.SPECIALTY_C 
       LEFT OUTER JOIN CLARITY_EPM ON har.PRIMARY_PAYOR_ID = CLARITY_EPM.PAYOR_ID 
       LEFT OUTER JOIN CLARITY_EPP ON har.PRIMARY_PLAN_ID = CLARITY_EPP.BENEFIT_PLAN_ID
       LEFT OUTER JOIN CLARITY_SER har_atd ON har.ATTENDING_PROV_ID = har_atd.PROV_ID
	   LEFT OUTER JOIN CLARITY_SER prov ON enc.VISIT_PROV_ID = prov.PROV_ID
	   --LEFT OUTER JOIN HSP_ATND_PROV atd ON pat_enc.PAT_ENC_CSN_ID = atd.PAT_ENC_CSN_ID
	   --LEFT OUTER JOIN Clarity_Ser ser_har_attend on atd.PROV_ID = ser_har_attend.prov_id
	   LEFT OUTER JOIN PATIENT ON enc.pat_id = PATIENT.pat_id
	   LEFT OUTER JOIN V_SCHED_APPT apt ON apt.pat_enc_csn_id = enc.pat_enc_csn_id
	   LEFT OUTER JOIN zc_language ON zc_language.language_c = patient.language_c
	   LEFT OUTER JOIN patient_race ON patient_race.pat_id = patient.pat_id
	   LEFT OUTER JOIN zc_patient_race ON zc_patient_race.patient_race_c = patient_race.patient_race_c
	   LEFT OUTER JOIN ethnic_background ON ethnic_background.pat_id = patient.pat_id
	   LEFT OUTER JOIN zc_ethnic_bkgrnd ON zc_ethnic_bkgrnd.ethnic_bkgrnd_c = ethnic_background.ethnic_bkgrnd_c
	   LEFT OUTER JOIN zc_religion ON zc_religion.religion_c = patient.religion_c
	   LEFT OUTER JOIN social_hx on social_hx.pat_enc_csn_id = enc.pat_enc_csn_id
	   LEFT OUTER JOIN zc_smoking_tob_use ON zc_smoking_tob_use.smoking_tob_use_c = social_hx.smoking_tob_use_c
	   LEFT OUTER JOIN patient_2 on patient_2.pat_id = patient.pat_id
	   /*
	   LEFT OUTER JOIN pat_enc csn1 on csn1.pat_id = enc.pat_id
	   AND csn1.contact_date IN 
	     (SELECT TOP 1 contact_date
		  FROM pat_enc
		  WHERE pat_id = enc.pat_id
		  ORDER BY csn1.contact_date DESC
		  )
	   */
	   --/*
		CROSS APPLY(
		SELECT TOP 1 pat_enc.pat_enc_csn_id, pat_enc.contact_date, pat_enc.BMI, pat_enc.appt_status_c
		FROM pat_enc
		WHERE pat_enc.pat_id = enc.pat_id AND pat_enc.appt_status_c NOT IN (3) AND pat_enc.contact_date < enc.contact_date
		ORDER BY pat_enc.contact_date DESC
		) AS csn1

		CROSS APPLY(
		SELECT TOP 1 pat_enc.pat_enc_csn_id, pat_enc.contact_date, pat_enc.BMI, pat_enc.appt_status_c
		FROM pat_enc
		WHERE pat_enc.pat_id = enc.pat_id AND pat_enc.appt_status_c NOT IN (3) AND pat_enc.contact_date < csn1.contact_date
		ORDER BY pat_enc.contact_date DESC
		) AS csn2
	   --*/
WHERE  (enc.SERV_AREA_ID = 40) 
       AND (enc.CONTACT_DATE >= @StartDate
              ) 
       AND (enc.CONTACT_DATE < @EndDate
              )
	   AND enc.APPT_STATUS_C NOT IN (3)
       AND (CLARITY_SER_SPEC.LINE IS NULL 
                     OR CLARITY_SER_SPEC.LINE = 1
              )
ORDER BY csn
