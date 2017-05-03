SELECT DISTINCT
    CASE WHEN har.serv_area_id = 20 THEN 'EAC'
         WHEN har.serv_area_id = 40 THEN 'SHV'
	END AS "Facility Name"
  , har.HSP_ACCOUNT_ID 'Patient_Account_Number'
  , CASE WHEN har.ACCT_BASECLS_HA_C = 1 THEN 'Inpatient'
		 WHEN har.ACCT_BASECLS_HA_C = 2 THEN 'Outpatient'
		 WHEN har.ACCT_BASECLS_HA_C = 3 THEN 'Outpatient'
    END AS 'Encounter_Type'
  , NULL 'IP_Service_Line'
  , NULL 'IP_Sub_Service_Line'
  , NULL 'OP_Service_Line'
  , NULL 'OP_Sub_Service_Line'
  , RIGHT(drg.drg_number,3) 'MSDRG_Code'
  , drg.drg_name 'MSDRG_Name'
  , DATEDIFF(DAY,patient.birth_date,GETDATE())/365 'Age'
  , CASE WHEN patient.sex_c = 1 THEN 'Female'
	     WHEN patient.sex_c = 2 THEN 'Male'
	END AS 'Gender'
  , patient.zip 'ZipCode'
  , FORMAT(har.adm_date_time, 'MM-dd-yyyy hh:mm') 'Admission_Date'
  , FORMAT(ol.surgery_date, 'MM-dd-yyyy hh:mm') 'Principal_Procedure_Date'
  , FORMAT(har.disch_date_time, 'MM-dd-yyyy hh:mm') 'Discharge_Date'
  , COALESCE(px1.ref_bill_code,cpt1.ref_bill_code) 'Principal_Procedure_Code'
  , COALESCE(px1.name,cpt1.name) 'Principal_Procedure_Name'
  , COALESCE(px2.ref_bill_code,cpt2.ref_bill_code)  'Secondary_Procedure_Code'
  , COALESCE(px2.name,cpt2.name) 'Secondary_Procedure_Name'
  , COALESCE(px3.ref_bill_code, cpt3.ref_bill_code)  'Third_Procedure_Code'
  , COALESCE(px3.name, cpt3.name) 'Third_Procedure_Name'
  , dx1.current_icd10_list 'Primary_Diagnosis_Code'
  , dx1.dx_name 'Primary_Diagnosis_Code_Description'
  , dx2.current_icd10_list 'Secondary_Diagnosis_Code'
  , dx2.dx_name 'Secondary_Diagnosis_Code_Description'
  , dx3.current_icd10_list 'Third_Diagnosis_Code'
  , dx3.dx_name 'Third_Diagnosis_Code_Description'
  , dx4.current_icd10_list 'Fourth_Diagnosis_Code'
  , dx4.dx_name 'Fourth_Diagnosis_Code_Description'
  , dx5.current_icd10_list 'Fifth_Diagnosis_Code'
  , dx5.dx_name 'Fifth_Diagnosis_Code_Description'
  , atd.prov_name 'Attending_Physician'
  , COALESCE(px1.px_perf_prov_nmwid,cpt1.px_perf_prov_nmwid) 'Procedure_Physician'
  , NULL 'Consulting_MD'
  , zfc.name 'Financial_Class'
  , NULL 'Direct_Variable_Cost'
  , NULL 'Total_Direct_Cost'
  , har.tot_chgs 'total_charges'
  , COALESCE(har.tot_pmts*-1,0) 'Net_Revenue'
  , adm_type.name 'Admission_Source'
  , CASE WHEN htr.ub_rev_code_id = '0762' THEN 1
		 ELSE 0
	END AS 'Observation_Cases'
  , CASE WHEN adm_type.name = 'Emergency' THEN 1
		 ELSE 0
	END AS 'ED_Cases'
  , CASE WHEN(DATEDIFF(DAY,har.adm_date_time,har.disch_date_time) = 0 AND har.ACCT_BASECLS_HA_C = 1) THEN 1
		 ELSE DATEDIFF(DAY,har.adm_date_time,har.disch_date_time) END AS 'LOS'
  , disp.name 'Discharge_Status'
  , NULL 'Readmission_Flag'

FROM (SELECT  ol.log_id log_id
			, enc.hsp_account_id
			, surgery_date
			, ol.pat_id
			, ol.room_id
			, primary_phys_id
			, ol.case_id
			, loc_id
			, proc_not_perf_c
			, status_c
			, ROW_NUMBER() OVER (PARTITION BY enc.hsp_account_id ORDER BY surgery_date) AS line
	 
	
	 FROM OR_LOG ol
	 LEFT OUTER JOIN PATIENT ON ol.PAT_ID = PATIENT.PAT_ID
	 LEFT OUTER JOIN pat_or_adm_link lnk ON lnk.log_id = ol.log_id
	 LEFT OUTER JOIN pat_enc_hsp enc ON enc.pat_enc_csn_id = or_link_csn
	 WHERE 
	      ol.proc_not_perf_c IS NULL
	  AND ol.status_c NOT IN ('4','6')
	  AND ol.PRIMARY_PHYS_ID IN (     '1083'
									 ,'1137'
				  					 ,'16140'
									 ,'1254'
									 ,'1258'
									 ,'1314'
									 ,'1320'
									 ,'16331'
									 ,'15895')
	 ) ol

LEFT OUTER JOIN PATIENT ON ol.PAT_ID = PATIENT.PAT_ID
LEFT OUTER JOIN CLARITY_SER cs ON ol.PRIMARY_PHYS_ID = cs.PROV_ID
LEFT OUTER JOIN zc_fin_class zfc ON prim_fc = zfc.fin_class_c
LEFT OUTER JOIN or_case ON ol.case_id = or_case.or_case_id
LEFT OUTER JOIN zc_or_service zco ON zco.service_c = or_case.service_c
LEFT OUTER JOIN v_case_volume v ON v.log_id = ol.log_id
LEFT OUTER JOIN pat_or_adm_link lnk ON lnk.log_id = ol.log_id
LEFT OUTER JOIN pat_enc_hsp enc ON enc.pat_enc_csn_id = or_link_csn
LEFT OUTER JOIN hsp_account har ON har.hsp_account_id = enc.hsp_account_id
LEFT OUTER JOIN clarity_ser atd ON atd.prov_id = har.attending_prov_id
LEFT OUTER JOIN clarity_ser_spec css ON css.prov_id = cs.prov_id
LEFT OUTER JOIN zc_specialty spec ON spec.specialty_c = css.specialty_c
LEFT OUTER JOIN clarity_drg drg ON drg.drg_id = har.final_drg_id
LEFT OUTER JOIN clarity_dep dep ON dep.department_id = har.disch_dept_id
LEFT OUTER JOIN zc_mc_adm_type adm_type ON adm_type.admission_type_c = har.admission_type_c
LEFT OUTER JOIN zc_disch_disp disp ON disp.disch_disp_c = enc.disch_disp_c
LEFT OUTER JOIN clarity_loc loc ON ol.loc_id = loc.loc_id

LEFT OUTER JOIN (SELECT DISTINCT ub_rev_code_id, hsp_account_id FROM hsp_transactions htr WHERE htr.ub_rev_code_id = '0762' ) htr ON har.hsp_account_id = htr.hsp_account_id

LEFT OUTER JOIN (SELECT edg.current_icd10_list, hadl.hsp_account_id, edg.dx_name
				 FROM hsp_acct_dx_list hadl LEFT OUTER JOIN clarity_edg edg ON edg.dx_id = hadl.dx_id
				 WHERE hadl.line = 1) dx1 ON dx1.hsp_account_id = har.hsp_account_id
LEFT OUTER JOIN (SELECT edg.current_icd10_list, hadl.hsp_account_id, edg.dx_name
				 FROM hsp_acct_dx_list hadl LEFT OUTER JOIN clarity_edg edg ON edg.dx_id = hadl.dx_id
				 WHERE hadl.line = 2) dx2 ON dx2.hsp_account_id = har.hsp_account_id
LEFT OUTER JOIN (SELECT edg.current_icd10_list, hadl.hsp_account_id, edg.dx_name
				 FROM hsp_acct_dx_list hadl LEFT OUTER JOIN clarity_edg edg ON edg.dx_id = hadl.dx_id
				 WHERE hadl.line = 3) dx3 ON dx3.hsp_account_id = har.hsp_account_id
LEFT OUTER JOIN (SELECT edg.current_icd10_list, hadl.hsp_account_id, edg.dx_name
				 FROM hsp_acct_dx_list hadl LEFT OUTER JOIN clarity_edg edg ON edg.dx_id = hadl.dx_id
				 WHERE hadl.line = 4) dx4 ON dx4.hsp_account_id = har.hsp_account_id
LEFT OUTER JOIN (SELECT edg.current_icd10_list, hadl.hsp_account_id, edg.dx_name
				 FROM hsp_acct_dx_list hadl LEFT OUTER JOIN clarity_edg edg ON edg.dx_id = hadl.dx_id
				 WHERE hadl.line = 5) dx5 ON dx5.hsp_account_id = har.hsp_account_id

LEFT OUTER JOIN (SELECT px.name, px.hsp_account_id, px.ref_bill_code, px.px_perf_prov_nmwid, px.PX_DATE
				 FROM v_coding_all_dx_px_list px
				 WHERE px.line = 1 AND px.source_abbr = 'ICD Px Prim Set') px1 on px1.hsp_account_id = har.hsp_account_id

LEFT OUTER JOIN (SELECT px.name, px.hsp_account_id, px.ref_bill_code
				 FROM v_coding_all_dx_px_list px
				 WHERE px.line = 2 AND px.source_abbr = 'ICD Px Prim Set') px2 on px2.hsp_account_id = har.hsp_account_id

LEFT OUTER JOIN (SELECT px.name, px.hsp_account_id, px.ref_bill_code
				 FROM v_coding_all_dx_px_list px
				 WHERE px.line = 3 AND px.source_abbr = 'ICD Px Prim Set') px3 on px3.hsp_account_id = har.hsp_account_id

LEFT OUTER JOIN (SELECT px.name, px.hsp_account_id, px.ref_bill_code, px.px_perf_prov_nmwid
				 FROM v_coding_all_dx_px_list px
				 WHERE px.source_abbr = 'Comb CPT' AND px.coding_info_cpt_line = 1) cpt1 on cpt1.hsp_account_id = har.hsp_account_id

LEFT OUTER JOIN (SELECT px.name, px.hsp_account_id, px.ref_bill_code
				 FROM v_coding_all_dx_px_list px
				 WHERE px.source_abbr = 'Comb CPT' AND px.coding_info_cpt_line = 2) cpt2 on cpt2.hsp_account_id = har.hsp_account_id

LEFT OUTER JOIN (SELECT px.name, px.hsp_account_id, px.ref_bill_code
				 FROM v_coding_all_dx_px_list px
				 WHERE px.source_abbr = 'Comb CPT' AND px.coding_info_cpt_line = 3) cpt3 on cpt3.hsp_account_id = har.hsp_account_id

WHERE 
	  ol.SURGERY_DATE >= '10/1/2015'
  AND ol.SURGERY_DATE < '4/1/2017'
  AND har.adm_date_time IS NOT NULL
  AND ol.proc_not_perf_c IS NULL
  AND ol.status_c NOT IN ('4','6')
  AND ol.line = 1
  AND ol.PRIMARY_PHYS_ID IN (     '1083'
								 ,'1137'
				  				 ,'16140'
								 ,'1254'
								 ,'1258'
								 ,'1314'
								 ,'1320'
								 ,'16331'
								 ,'15895')

