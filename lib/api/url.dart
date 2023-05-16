class url{
 static String dm = 'http://103.82.248.220';
}
class pathurl{
  static String urllogin = '${url.dm}/api/v1/mobile/authen/login';
  static String urlcom = '${url.dm}/api/v1/mobile/company';
  static String urlprofile = '${url.dm}/api/v1/mobile/user/profile';

  ///////////////////////////////กำลังพล////////////////////////////////////////////////////////////////////////////////
  static String urldataHumanById = '${url.dm}/api/v1/mobile/request_personnel/posts/';
  static String senddataHuman = '${url.dm}/api/v1/mobile/request_personnel/posts';
  static String urldataApprove = '${url.dm}/api/v1/mobile/request_personnel/approve';
  static String listEmpName = '${url.dm}/api/v1/mobile/request_personnel/employee';
  static String setStatus = '${url.dm}/api/v1/mobile/request_personnel/approve/';
  static String req_pos = "${url.dm}/api/v1/mobile/request_personnel/position";
  static String emp_type = "${url.dm}/api/v1/mobile/configuration/employment_type";


  static String edu = "${url.dm}/api/v1/mobile/configuration/education_level";
  static String settingApprove = "${url.dm}/api/v1/mobile/user/setting_approve";
  static String settingHoliday = "${url.dm}/api/v1/mobile/user/setting_working_holidays";
  static String settingWKa = "${url.dm}/api/v1/mobile/user/setting_workcycle";

  ///////////////////////////////ใบลา////////////////////////////////////////////////////////////////////////////////
  static String listLa = "${url.dm}/api/v1/mobile/configuration/leave_type";
  static String dataLa = "${url.dm}/api/v1/mobile/request_leave/posts";
  static String searchDataLa = "${url.dm}/api/v1/mobile/request_leave/posts/";
  static String dataLaById = "${url.dm}/api/v1/mobile/request_leave/posts/";
  static String dataSearchListEmpName = "${url.dm}/api/v1/mobile/request_leave/employee";
  static String dataApproveDocLa = "${url.dm}/api/v1/mobile/request_leave/approve";
  static String dataAllApproveDocLa = "${url.dm}/api/v1/mobile/request_leave/approve";
  static String setStatusDocLa = '${url.dm}/api/v1/mobile/request_leave/approve/';
  static String weekHoliday = '${url.dm}/api/v1/mobile/user/holidays';
  static String yearHoliday = '${url.dm}/api/v1/mobile/annual_holiday';
  static String leaveformat = '${url.dm}/api/v1/mobile/configuration/leave_format';
  static String editLa = '${url.dm}/api/v1/mobile/request_leave/posts/edit/';

  ///////////////////////////////กะ///////////////////////////////////////////////////////////////////////////////
  static String listKA = '${url.dm}/api/v1/mobile/configuration/work_cycle';
  static String listPosKa = '${url.dm}/api/v1/mobile/request_workcycle/positions';
  static String Allemployee = '${url.dm}/api/v1/mobile/request_workcycle/employee';
  static String getDTKID = '${url.dm}/api/v1/mobile/request_workcycle/posts/';
  static String sendDTK = '${url.dm}/api/v1/mobile/request_workcycle/posts/';
  static String editDTK = '${url.dm}/api/v1/mobile/request_workcycle/posts/edit/';
  static String getDTK = '${url.dm}/api/v1/mobile/request_workcycle/posts';
  static String getDTKCalendar = '${url.dm}/api/v1/mobile/calendar/';
  static String setStatusKa = '${url.dm}/api/v1/mobile/request_workcycle/update_status/';

  ///////////////////////////////โอที////////////////////////////////////////////////////////////////////////////////
  static String listOT = '${url.dm}/api/v1/mobile/configuration/ot_type';
  static String listPosOT = '${url.dm}/api/v1/mobile/request_ot/positions';
  static String listEmpOT = '${url.dm}/api/v1/mobile/request_ot/employee';
  static String sendDOT = '${url.dm}/api/v1/mobile/request_ot/posts';
  static String getDOT = '${url.dm}/api/v1/mobile/request_ot/posts';
  static String getDOTID = '${url.dm}/api/v1/mobile/request_ot/posts/';
  static String editOT = '${url.dm}/api/v1/mobile/request_ot/posts/edit/';
  static String updateOT = '${url.dm}/api/v1/mobile/request_ot/posts/';
  static String setStatusOT = '${url.dm}/api/v1/mobile/request_ot/update_status/';

  ///////////////////////////////วันหยุด///////////////////////////////////////////////////////////////////////////////
  static String listempHoly = '${url.dm}/api/v1/mobile/request_changeholiday/employee';
  static String listPosHoly = '${url.dm}/api/v1/mobile/request_changeholiday/positions';
  static String getDTH = '${url.dm}/api/v1/mobile/request_changeholiday/posts/';
  static String serchDTH = '${url.dm}/api/v1/mobile/request_changeholiday/posts';
  static String sendDTH = '${url.dm}/api/v1/mobile/request_changeholiday/posts/';


  ///////////////////////////////เพิ่มเวลา///////////////////////////////////////////////////////////////////////////////
  static String listHedPon = '${url.dm}/api/v1/mobile/configuration/reason_addtime';
  static String sendDTHedPon = '${url.dm}/api/v1/mobile/request_addtime/posts';
  static String getDTHedPon = '${url.dm}/api/v1/mobile/request_addtime/posts';
  static String getDTHedPonID = '${url.dm}/api/v1/mobile/request_addtime/posts/';
  static String getDTHedPonEditID = '${url.dm}/api/v1/mobile/request_addtime/edit/';
  static String updateDTHedPonEditID = '${url.dm}/api/v1/mobile/request_addtime/posts/';
  static String checkStatusday = '${url.dm}/api/v1/mobile/calendar/event/';
  /*****************************ผู้อนุมัติ*************************************/
  static String getDTApDocAddTime = '${url.dm}/api/v1/mobile/request_addtime/approve';
  static String updateStatusDocAddtime = '${url.dm}/api/v1/mobile/request_addtime/approve/';

  ///////////////////////////////ลาออก/////////////////////////////////////////////////////////////////////////////////////////
  static String getDTResign = '${url.dm}/api/v1/mobile/resignation/posts';
  static String getDTResignID = '${url.dm}/api/v1/mobile/resignation/posts/';
  static String sendDTResign = '${url.dm}/api/v1/mobile/resignation/posts';
  static String updateDTResignEditID = '${url.dm}/api/v1/mobile/resignation/posts/';
  /*****************************ผู้อนุมัติ*************************************/
  static String getDTAppDocResign = '${url.dm}/api/v1/mobile/resignation/approve';
  static String setStatusDocResign = '${url.dm}/api/v1/mobile/resignation/update_status/';

  ///////////////////////////////เอกสารรับรองเงินเดือน///////////////////////////////////////////////////////////////////////////////
  static String getDTDocSalaryCer = '${url.dm}/api/v1/mobile/salary_certificate/posts';
  static String getDTDocSalaryCerID = '${url.dm}/api/v1/mobile/salary_certificate/posts/';
  static String sendDTDocSalaryCer = '${url.dm}/api/v1/mobile/salary_certificate/posts';
  static String updateDTDocSalaryCerID = '${url.dm}/api/v1/mobile/salary_certificate/posts/';
  static String setStatusDTDocSalaryCerID = '${url.dm}/api/v1/mobile/salary_certificate/update_status/';

  ///////////////////////////////เอกสารรับรองการทำงาน///////////////////////////////////////////////////////////////////////////////
  static String getDTDocWorkCer = '${url.dm}/api/v1/mobile/employment_certificate/posts';
  static String getDTDocWorkCerID = '${url.dm}/api/v1/mobile/employment_certificate/posts/';
  static String sendDTDocWorkCer = '${url.dm}/api/v1/mobile/employment_certificate/posts';
  static String updateDTDocWorkCerID = '${url.dm}/api/v1/mobile/employment_certificate/posts/';
  static String setStatusDTDocWorkCerID = '${url.dm}/api/v1/mobile/employment_certificate/update_status/';

  ///////////////////////////////หนังสือเตือน///////////////////////////////////////////////////////////////////////////////
  static String listPunish = '${url.dm}/api/v1/mobile/warning_letter/punish';
  static String listempWarning = '${url.dm}/api/v1/mobile/warning_letter/employee';
  static String listPosWarning = '${url.dm}/api/v1/mobile/warning_letter/positions';
  static String getDTDocWarning = '${url.dm}/api/v1/mobile/warning_letter/posts';
  static String getDTDocWarningID = '${url.dm}/api/v1/mobile/warning_letter/posts/';
  static String sendDTDocWarning = '${url.dm}/api/v1/mobile/warning_letter/posts';
  static String updateDTDocWarningID = '${url.dm}/api/v1/mobile/warning_letter/posts/';
  static String setStatusDTDocWarningID = '${url.dm}/api/v1/mobile/warning_letter/update_status/';

  ///////////////////////////////เปลี่ยนสภาพพนักงาน///////////////////////////////////////////////////////////////////////////////
  static String listCondition = '${url.dm}/api/v1/mobile/change_condition/title';
  static String listPosCondition = '${url.dm}/api/v1/mobile/change_condition/positions';
  static String listempCondition = '${url.dm}/api/v1/mobile/change_condition/employee';
  static String getDTDocCondition = '${url.dm}/api/v1/mobile/change_condition/posts';
  static String getDTDocConditionID = '${url.dm}/api/v1/mobile/change_condition/posts/';
  static String sendDTDocCondition = '${url.dm}/api/v1/mobile/change_condition/posts';
  static String updateDTDocConditionID = '${url.dm}/api/v1/mobile/change_condition/posts/';
  static String setStatusDTDocConditionID = '${url.dm}/api/v1/mobile/change_condition/update_status/';


  ///////////////////////////////บันทึกความดี///////////////////////////////////////////////////////////////////////////////
  static String myScore = '${url.dm}/api/v1/mobile/score_sheet/';
  static String listPosScore = '${url.dm}/api/v1/mobile/configuration/second_position';
  static String listempScore = '${url.dm}/api/v1/mobile/score_sheet/employee';
  static String getDTDocScore = '${url.dm}/api/v1/mobile/score_sheet/posts';
  static String getDTDocScoreID = '${url.dm}/api/v1/mobile/score_sheet/posts/';
  static String sendDTDocScore = '${url.dm}/api/v1/mobile/score_sheet/posts';
  static String updateDTDocScoreID = '${url.dm}/api/v1/mobile/score_sheet/posts/';
  static String ScoreEmp = "${url.dm}/api/v1/mobile/score_sheet/total/";
  // String setStatusDTDocConditionID = 'http://103.82.248.220/api/v1/mobile/change_condition/update_status/';


  ///////////////////////////////ใบสมัคร///////////////////////////////////////////////////////////////////////////////
  static String listjob = '${url.dm}/api/v1/mobile/job_application/share';
  static String setstatusjob = '${url.dm}/api/v1/mobile/job_application/share/';

  ///////////////////////////////เวลาเข้า-ออก///////////////////////////////////////////////////////////////////////////////
  static String timeINOUT = '${url.dm}/api/v1/mobile/time_manage/today';

  ///////////////////////////////Even Calendar///////////////////////////////////////////////////////////////////////////////
  static String eventCalendarToday = '${url.dm}/api/v1/mobile/calendar/today';


  ///////////////////////////////2ตำแหน่ง///////////////////////////////////////////////////////////////////////////////
  static String secPosition = '${url.dm}/api/v1/mobile/configuration/second_position';

/********************************************************************************************************************************/
/*****************เเเเเเเเเเเเเเเเเเเเเเเเเเเอกสารถึงฉันนนนนนนนนนนนนนนนนนนนนนนนนนนนนนนนนนนนน*****************************************************/
/********************************************************************************************************************************/

///////////////////////////////กะ//////////////////////////////////////////////////////////////////////////////////////////
  static String dtmKa = '${url.dm}/api/v1/mobile/request_workcycle/doc_to';
  static String dtmKaId = '${url.dm}/api/v1/mobile/request_workcycle/doc_to/';

  ///////////////////////////////วันหยุด//////////////////////////////////////////////////////////////////////////////////////////
  static String dtmHolyday = '${url.dm}/api/v1/mobile/request_changeholiday/doc_to';
  static String dtmHolydayId = '${url.dm}/api/v1/mobile/request_changeholiday/doc_to/';

  ///////////////////////////////โอที//////////////////////////////////////////////////////////////////////////////////////////
  static String dtmOT = '${url.dm}/api/v1/mobile/request_ot/doc_to';
  static String dtmOTId = '${url.dm}/api/v1/mobile/request_ot/doc_to/';

  ///////////////////////////////ใบเตือน//////////////////////////////////////////////////////////////////////////////////////////
  static String dtmWarning = '${url.dm}/api/v1/mobile/warning_letter/doc_to';
  static String dtmWarningId = '${url.dm}/api/v1/mobile/warning_letter/doc_to/';

  ///////////////////////////////ใบเปลี่ยนสภาพ//////////////////////////////////////////////////////////////////////////////////////////
  static String dtmCondition = '${url.dm}/api/v1/mobile/change_condition/doc_to';
  static String dtmKConditionId = '${url.dm}/api/v1/mobile/change_condition/doc_to/';

  ///////////////////////////////ใบคะแนน//////////////////////////////////////////////////////////////////////////////////////////
  static String dtmScore = '${url.dm}/api/v1/mobile/score_sheet/doc_to';
  static String dtmScoreId = '${url.dm}/api/v1/mobile/score_sheet/doc_to/';


  ///////////////////////////////เอกสารแผนก//////////////////////////////////////////////////////////////////////////////////////////
  static String docdep = '${url.dm}/api/v1/mobile/document/folder';

  ///////////////////////////////โฟล์เดอร์//////////////////////////////////////////////////////////////////////////////////////////
  /*ขอกำลังพล*/
  static String fHuman = '${url.dm}/api/v1/mobile/document/folder/request_personnel';
  static String fHumanId = '${url.dm}/api/v1/mobile/document/folder/request_personnel/';

  /*ลา*/
  static String fLa = '${url.dm}/api/v1/mobile/document/folder/leave';
  static String fLaId = '${url.dm}/api/v1/mobile/document/folder/leave/';

  /*เพิ่มเวลา*/
  static String fTime = '${url.dm}/api/v1/mobile/document/folder/add-time';
  static String fTimeId = '${url.dm}/api/v1/mobile/document/folder/add-time/';

  /*ลาออก*/
  static String fResign = '${url.dm}/api/v1/mobile/document/folder/resignation';
  static String fResignId = '${url.dm}/api/v1/mobile/document/folder/resignation/';

  /*เปลี่ยนกะทำงาน*/
  static String fKa = '${url.dm}/api/v1/mobile/document/folder/work-cycle';
  static String fKaId = '${url.dm}/api/v1/mobile/document/folder/work-cycle/';


  /*เปลี่ยนวันหยุด*/
  static String fHoly = '${url.dm}/api/v1/mobile/document/folder/holiday';
  static String fHolyId = '${url.dm}/api/v1/mobile/document/folder/holiday/';

  /*โอที*/
  static String fOT = '${url.dm}/api/v1/mobile/document/folder/ot';
  static String fOTId = '${url.dm}/api/v1/mobile/document/folder/ot/';

  /*หนังสือเตือน*/
  static String fWarning = '${url.dm}/api/v1/mobile/document/folder/warning_letter';
  static String fWarningId = '${url.dm}/api/v1/mobile/document/folder/warning_letter/';

  /*ใบแจ้งเปลี่ยนสภาพ*/
  static String fCondition = '${url.dm}/api/v1/mobile/document/folder/change_condition';
  static String fConditionId = '${url.dm}/api/v1/mobile/document/folder/change_condition/';

  /*บันทึกความดี*/
  static String fScore = '${url.dm}/api/v1/mobile/document/folder/score_sheet';
  static String fScoreId = '${url.dm}/api/v1/mobile/document/folder/score_sheet/';

  /***************************************************************************************************************************/
  ////////////////////////////////////////////ข้อมูลส่วนตัว////////////////////////////////////////////////////////////////////////
  static String reAddress = '${url.dm}/api/v1/mobile/user/resume/address';
  static String reFamily = '${url.dm}/api/v1/mobile/user/resume/family';
  static String reWorkHis = '${url.dm}/api/v1/mobile/user/resume/work-history';
  static String reEduHis = '${url.dm}/api/v1/mobile/user/resume/education-history';
  static String reTalent = '${url.dm}/api/v1/mobile/user/resume/talents';
  static String reDocs = '${url.dm}/api/v1/mobile/user/resume/docs';

  ////////////////////////////////////////////ข้อมูลการฝึกอบรม////////////////////////////////////////////////////////////////////////
  static String userTraining = '${url.dm}/api/v1/mobile/user/training';

  ////////////////////////////////////////////ข้อมูลการฝึกอบรม////////////////////////////////////////////////////////////////////////
  static String userAssets = '${url.dm}/api/v1/mobile/user/assets';

  ////////////////////////////////////////////โรงบาลตามสิทธิ์////////////////////////////////////////////////////////////////////////
  static String userHospital = '${url.dm}/api/v1/mobile/user/hospital';

  ////////////////////////////////////////////รายรับ-จ่าย////////////////////////////////////////////////////////////////////////
  static String userIncomeExpen = '${url.dm}/api/v1/mobile/user/fixed_income_expenses';




}