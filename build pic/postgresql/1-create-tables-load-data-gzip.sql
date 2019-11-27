DROP TABLE IF EXISTS ADMISSIONS;
CREATE TABLE ADMISSIONS
(	
   -- rows=13449
   ROW_ID SMALLINT NOT NULL,
   SUBJECT_ID INTEGER NOT NULL,
   HADM_ID INTEGER NOT NULL,
   ADMITTIME TIMESTAMP NOT NULL,
   DISCHTIME TIMESTAMP NOT NULL,
   DEATHTIME VARCHAR(20),
   ADMISSION_DEPARTMENT VARCHAR(255) NOT NULL,	
   DISCHARGE_DEPARTMENT VARCHAR(255) NOT NULL,	
   INSURANCE VARCHAR(255) NOT NULL,	
   LANGUAGE VARCHAR(255),	
   RELIGION VARCHAR(255),	
   MARITAL_STATUS VARCHAR(255),	
   ETHNICITY VARCHAR(255) NOT NULL,	
   EDREGTIME TIMESTAMP NOT NULL,
   EDOUTTIME TIMESTAMP NOT NULL,
   DIAGNOSIS VARCHAR(255),
   ICD10_CODE_CN VARCHAR(255), 	
   HOSPITAL_EXPIRE_FLAG SMALLINT NOT NULL,
   HAS_CHARTEVENTS_DATA SMALLINT NOT NULL,
  CONSTRAINT ADMISSIONS_ROW_ID UNIQUE (ROW_ID),	-- nvals=13449
  CONSTRAINT ADMISSIONS_HADM_ID UNIQUE (HADM_ID)	-- nvals=13449
);

\COPY admissions FROM PROGRAM 'gzip -dc ADMISSIONS.csv.gz' CSV HEADER NULL ''

-- convert varchar column with nulls to date
-- UPDATE admissions SET DEATHTIME=NULL WHERE TRIM(DEATHTIME) = '';
ALTER TABLE admissions ALTER COLUMN deathtime TYPE TIMESTAMP USING CAST(deathtime AS timestamp);

DROP TABLE IF EXISTS CHARTEVENTS;
CREATE TABLE CHARTEVENTS (	-- rows=1033301
   ROW_ID INT NOT NULL,
   SUBJECT_ID INTEGER NOT NULL,
   HADM_ID INTEGER NOT NULL,
   ICUSTAY_ID VARCHAR(10),
   ITEMID VARCHAR(255) NOT NULL,
   CHARTTIME TIMESTAMP NOT NULL,
   STORETIME TIMESTAMP,
   VALUE VARCHAR(255),	
   VALUENUM FLOAT,
   VALUEUOM VARCHAR(255),
  CONSTRAINT CHARTEVENTS_ROW_ID UNIQUE (ROW_ID)	-- nvals=1033301
  );

\COPY chartevents FROM PROGRAM 'gzip -dc CHARTEVENTS.csv.gz' CSV HEADER NULL ''

DROP TABLE IF EXISTS DIAGNOSES_ICD;
CREATE TABLE DIAGNOSES_ICD (	-- rows=13365
   ROW_ID INTEGER NOT NULL,
   SUBJECT_ID INTEGER NOT NULL,
   HADM_ID INTEGER NOT NULL,
   SEQ_NUM SMALLINT NOT NULL,
   ICD10_CODE_CN VARCHAR(255) NOT NULL,	
  CONSTRAINT DIAGNOSES_ICD_ROW_ID UNIQUE (ROW_ID)	-- nvals=13365
  );

\COPY DIAGNOSES_ICD FROM PROGRAM 'gzip -dc DIAGNOSES_ICD.csv.gz' CSV HEADER NULL ''

DROP TABLE IF EXISTS D_ICD_DIAGNOSES;
CREATE TABLE D_ICD_DIAGNOSES (	-- rows=25378
   ROW_ID SMALLINT NOT NULL,
   ICD10_CODE_CN VARCHAR(255) NOT NULL,
   ICD10_CODE CHAR(7),	
   TITLE_CN VARCHAR(255) NOT NULL,	
   TITLE VARCHAR(255) NOT NULL,	
  CONSTRAINT D_ICD_DIAGNOSES_ROW_ID UNIQUE (ROW_ID),	-- nvals=25378
  CONSTRAINT D_ICD_DIAGNOSES_ICD10_CODE_CN UNIQUE (ICD10_CODE_CN)	-- nvals=25378
  );

\COPY D_ICD_DIAGNOSES FROM PROGRAM 'gzip -dc D_ICD_DIAGNOSES.csv.gz' CSV HEADER NULL ''

DROP TABLE IF EXISTS D_ITEMS;
CREATE TABLE D_ITEMS (	-- rows=465
   ROW_ID SMALLINT NOT NULL,
   ITEMID VARCHAR(255) NOT NULL,
   LABEL_CN VARCHAR(255)NOT NULL,
   LABEL TEXT NOT NULL,	
   LINKSTO VARCHAR(255) NOT NULL,	
   CATEGORY VARCHAR(255),	
   UNITNAME VARCHAR(255),		
  CONSTRAINT D_ITEMS_ROW_ID UNIQUE (ROW_ID),	
  CONSTRAINT D_ITEMS_ITEMID UNIQUE (ITEMID)	
  );

\COPY D_ITEMS FROM PROGRAM 'gzip -dc D_ITEMS.csv.gz' CSV HEADER NULL ''

DROP TABLE IF EXISTS D_LABITEMS;
CREATE TABLE D_LABITEMS (	-- rows=832
   ROW_ID SMALLINT NOT NULL,
   ITEMID SMALLINT NOT NULL,
   LABEL_CN TEXT NOT NULL,
   LABEL VARCHAR(255) NOT NULL,
   FLUID VARCHAR(255),
   CATEGORY VARCHAR(255),
   LOINC_CODE VARCHAR(255),
  CONSTRAINT D_LABITEMS_ROW_ID UNIQUE (ROW_ID),	-- nvals=832
  CONSTRAINT D_LABITEMS_ITEMID UNIQUE (ITEMID)	-- nvals=832
  );

\COPY D_LABITEMS FROM PROGRAM 'gzip -dc D_LABITEMS.csv.gz' CSV HEADER NULL ''

DROP TABLE IF EXISTS EMR_SYMPTOMS;
CREATE TABLE EMR_SYMPTOMS (	-- rows=402142
   ROW_ID INTEGER NOT NULL,
   SUBJECT_ID INTEGER NOT NULL,
   HADM_ID INTEGER NOT NULL,
   EMR_ID INTEGER NOT NULL,
   RECORDTIME TIMESTAMP NOT NULL,
   SYMPTOM_NAME_CN VARCHAR(255) NOT NULL,
   SYMPTOM_NAME VARCHAR(255) NOT NULL,
   SYMPTOM_ATTRIBUTE VARCHAR(255) NOT NULL,
  CONSTRAINT EMR_SYMPTOMS_ROW_ID UNIQUE (ROW_ID)	-- nvals=402142
  );

\COPY EMR_SYMPTOMS FROM PROGRAM 'gzip -dc EMR_SYMPTOMS.csv.gz' CSV HEADER NULL ''

DROP TABLE IF EXISTS ICUSTAYS;
CREATE TABLE ICUSTAYS (	-- rows=13941
   ROW_ID SMALLINT NOT NULL,
   SUBJECT_ID INTEGER NOT NULL,
   HADM_ID INTEGER NOT NULL,
   ICUSTAY_ID INTEGER NOT NULL,
   FIRST_CAREUNIT VARCHAR(255) NOT NULL,	
   LAST_CAREUNIT VARCHAR(255) NOT NULL,	
   FIRST_WARDID SMALLINT NOT NULL,
   LAST_WARDID SMALLINT NOT NULL,
   INTIME TIMESTAMP NOT NULL,
   OUTTIME TIMESTAMP NOT NULL,
   LOS FLOAT NOT NULL,
  CONSTRAINT ICUSTAYS_ROW_ID UNIQUE (ROW_ID),	-- nvals=13941
  CONSTRAINT ICUSTAYS_ICUSTAY_ID UNIQUE (ICUSTAY_ID)	-- nvals=13941
  );

\COPY ICUSTAYS FROM PROGRAM 'gzip -dc ICUSTAYS.csv.gz' CSV HEADER NULL ''

DROP TABLE IF EXISTS LABEVENTS;
CREATE TABLE LABEVENTS (	-- rows=10094117
   ROW_ID INT NOT NULL,
   SUBJECT_ID INTEGER NOT NULL,
   HADM_ID INTEGER NOT NULL,
   ITEMID SMALLINT NOT NULL,
   CHARTTIME TIMESTAMP NOT NULL,
   VALUE TEXT NOT NULL,
   VALUENUM FLOAT,
   VALUEUOM VARCHAR(255),	
   FLAG VARCHAR(255),	
  CONSTRAINT LABEVENTS_ROW_ID UNIQUE (ROW_ID)	-- nvals=10094117
  );

\COPY LABEVENTS FROM PROGRAM 'gzip -dc LABEVENTS.csv.gz' CSV HEADER NULL '' FORCE NULL VALUENUM

DROP TABLE IF EXISTS MICROBIOLOGYEVENTS;
CREATE TABLE MICROBIOLOGYEVENTS (	-- rows=183869
   ROW_ID INTEGER NOT NULL,
   SUBJECT_ID INTEGER NOT NULL,
   HADM_ID INTEGER NOT NULL,
   CHARTTIME TIMESTAMP NOT NULL,
   SPEC_ITEMID TEXT NOT NULL,
   SPEC_TYPE_DESC TEXT NOT NULL,
   ORG_ITEMID VARCHAR(255),
   ORG_NAME VARCHAR(255),	
   AB_ITEMID VARCHAR(255),
   AB_NAME VARCHAR(255),	
   DILUTION_TEXT VARCHAR(255),	
   DILUTION_COMPARISON VARCHAR(255),	
   DILUTION_VALUE FLOAT,
   INTERPRETATION VARCHAR(255),	
  CONSTRAINT MICROBIOLOGYEVENTS_ROW_ID UNIQUE (ROW_ID)	-- nvals=183869
  );

\COPY MICROBIOLOGYEVENTS FROM PROGRAM 'gzip -dc MICROBIOLOGYEVENTS.csv.gz' CSV HEADER NULL '' FORCE NULL DILUTION_VALUE

DROP TABLE IF EXISTS OR_EXAM_REPORTS;
CREATE TABLE OR_EXAM_REPORTS (	-- rows=183809
   ROW_ID INTEGER NOT NULL,
   SUBJECT_ID INTEGER NOT NULL,
   HADM_ID INTEGER NOT NULL,
   EXAMTIME TIMESTAMP,
   REPORTTIME TIMESTAMP,
   EXAM_ITEM_TYPE_NAME VARCHAR(255),
   EXAM_ITEM_NAME VARCHAR(255),
   EXAM_PART_NAME VARCHAR(255),	
  CONSTRAINT OR_EXAM_REPORTS_ROW_ID UNIQUE (ROW_ID)	-- nvals=183809
  );

\COPY OR_EXAM_REPORTS FROM PROGRAM 'gzip -dc OR_EXAM_REPORTS.csv.gz' CSV HEADER NULL '' FORCE NULL examtime

DROP TABLE IF EXISTS OUTPUTEVENTS;
CREATE TABLE OUTPUTEVENTS (	-- rows=39891
   ROW_ID INTEGER NOT NULL,
   SUBJECT_ID INTEGER NOT NULL,
   HADM_ID INTEGER NOT NULL,
   ICUSTAY_ID VARCHAR(10),
   CHARTTIME TIMESTAMP NOT NULL,
   ITEMID VARCHAR(255) NOT NULL,
   VALUE FLOAT NOT NULL,
   VALUEUOM VARCHAR(255),	
   STORETIME TIMESTAMP NOT NULL,
  CONSTRAINT OUTPUTEVENTS_ROW_ID UNIQUE (ROW_ID)	-- nvals=39891
  );

\COPY OUTPUTEVENTS FROM PROGRAM 'gzip -dc OUTPUTEVENTS.csv.gz' CSV HEADER NULL ''

DROP TABLE IF EXISTS PATIENTS;
CREATE TABLE PATIENTS (	-- rows=12881
   ROW_ID SMALLINT NOT NULL,
   SUBJECT_ID INTEGER NOT NULL,
   GENDER VARCHAR(255) NOT NULL,
   DOB TIMESTAMP NOT NULL,	
   DOD TIMESTAMP,
   EXPIRE_FLAG SMALLINT NOT NULL,
  CONSTRAINT PATIENTS_ROW_ID UNIQUE (ROW_ID),	-- nvals=12881
  CONSTRAINT PATIENTS_SUBJECT_ID UNIQUE (SUBJECT_ID)	-- nvals=12881
  );

\COPY PATIENTS FROM PROGRAM 'gzip -dc PATIENTS.csv.gz' CSV HEADER NULL '' FORCE NULL dod

DROP TABLE IF EXISTS PRESCRIPTIONS;
CREATE TABLE PRESCRIPTIONS (	-- rows=1256591
   ROW_ID INTEGER NOT NULL,
   SUBJECT_ID INTEGER NOT NULL,
   HADM_ID INTEGER NOT NULL,
   ICUSTAY_ID VARCHAR(10),
   STARTDATE TIMESTAMP,
   ENDDATE TIMESTAMP,
   DRUG_NAME_CN VARCHAR(255) NOT NULL,
   DRUG_NAME VARCHAR(255) NOT NULL,	
   PROD_STRENGTH VARCHAR(255),
   DRUG_NAME_GENERIC VARCHAR(255),	
   DOSE_VAL_RX VARCHAR(255) NOT NULL,	
   DOSE_UNIT_RX VARCHAR(255),	
   DRUG_FORM VARCHAR(255),	
  CONSTRAINT PRESCRIPTIONS_ROW_ID UNIQUE (ROW_ID)	-- nvals=1256591
  );


\COPY PRESCRIPTIONS FROM PROGRAM 'gzip -dc PRESCRIPTIONS.csv.gz' CSV HEADER NULL '' FORCE NULL STARTDATE, ENDDATE

DROP TABLE IF EXISTS SURGERY_VITAL_SIGNS;
CREATE TABLE SURGERY_VITAL_SIGNS (	-- rows=1216011
   ROW_ID INTEGER NOT NULL,
   SUBJECT_ID INTEGER NOT NULL,
   HADM_ID INTEGER NOT NULL,
   VISIT_ID SMALLINT NOT NULL,
   OPER_ID SMALLINT NOT NULL,
   ITEM_NO INTEGER NOT NULL,
   MONITORTIME TIMESTAMP NOT NULL,
   ITEMID VARCHAR(255) NOT NULL,
   VALUE SMALLINT NOT NULL,
  CONSTRAINT SURGERY_VITAL_SIGNS_ROW_ID UNIQUE (ROW_ID)	-- nvals=1216011
  );
  
\COPY SURGERY_VITAL_SIGNS FROM PROGRAM 'gzip -dc SURGERY_VITAL_SIGNS.csv.gz' CSV HEADER NULL ''
