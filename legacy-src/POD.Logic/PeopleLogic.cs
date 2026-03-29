using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using POD.Data.Entities;
using POD.Data;

namespace POD.Logic
{
    public static class PeopleLogic
    {
        /// <summary>
        /// adds a person or updates person record
        /// </summary>
        /// <param name="key"></param>
        /// <param name="personTypeID"></param>
        /// <param name="communityid"></param>
        /// <param name="statustypeid"></param>
        /// <param name="countyid"></param>
        /// <param name="djjnum"></param>
        /// <param name="firstname"></param>
        /// <param name="lastname"></param>
        /// <param name="middlename"></param>
        /// <param name="email"></param>
        /// <param name="title"></param>
        /// <param name="company"></param>
        /// <param name="salutation"></param>
        /// <param name="honor"></param>
        /// <param name="genderid"></param>
        /// <param name="dob"></param>
        /// <param name="primLanguage"></param>
        /// <param name="secLanguage"></param>
        /// <param name="notes"></param>
        /// <returns></returns>
        public static int AddUpdatePerson(int? key, int personTypeID, int? communityid, int statustypeid, int? countyid, string djjnum, string firstname, string lastname,
                                         string middlename, string email, string title, string company, string salutation, string honor, int? genderid,
                                             DateTime? dob, string primLanguage, string secLanguage, string notes)
        {
            return POD.Data.PeopleData.AddUpdatePerson(key, personTypeID, communityid, statustypeid, countyid, djjnum, firstname, lastname,
                                            middlename, email, title, company, salutation, honor, genderid,
                                                dob, primLanguage, secLanguage, notes, Security.GetCurrentUserProfile().UserName);
        }

        /// <summary>
        /// adds student related information
        /// </summary>
        /// <param name="personid"></param>
        /// <param name="school"></param>
        /// <param name="gradeLevel"></param>
        /// <param name="partcipateInProg"></param>
        /// <returns></returns>
        public static string AddUpdateStudentInfo(int personid, string school, string gradeLevel, bool? partcipateInProg, int studentTypeid, int? caseMrgPersonid)
        {
            Student existingStudent = POD.Data.PeopleData.GetPersonByID(personid) as Student;
            if (existingStudent != null)
            {
                return POD.Data.PeopleData.AddUpdateStudentInfo(personid, Security.GetCurrentUserProfile().UserName, school, gradeLevel, partcipateInProg, studentTypeid,
                                    existingStudent.PartOtherProgNames, existingStudent.Medications, existingStudent.MedicalConditions, existingStudent.MedicalSpecialNeeds,
                                        existingStudent.RideBusAlone, existingStudent.SignInOut, existingStudent.WalkHomeAlone,
                                           existingStudent.RideBikeHomeAlone, existingStudent.SignedInOutGuardOnly,
                                            caseMrgPersonid);

            }
            else
            {
                return POD.Data.PeopleData.AddUpdateStudentInfo(personid, Security.GetCurrentUserProfile().UserName, school, gradeLevel, partcipateInProg, studentTypeid, null, null, null,
                                                                null, false, false, false, false, false, caseMrgPersonid);
            }
        }

        /// <summary>
        /// adds student related information
        /// </summary>
        /// <param name="personid"></param>
        /// <param name="school"></param>
        /// <param name="gradeLevel"></param>
        /// <param name="partcipateInProg"></param>
        /// <returns></returns>
        public static string AddUpdateStudentInfo(int personid, string school, string gradeLevel, bool? partcipateInProg, int studentTypeid, string otherSchoolName, string meds, string medicalConditions, string speiclaNeeds,
                                                 bool rideBusAlone, bool signOut, bool walkHomeAlone, bool rideBikeAlone, bool signOuByGuardOnly, int? caseMrgPersonid)
        {

            return POD.Data.PeopleData.AddUpdateStudentInfo(personid, Security.GetCurrentUserProfile().UserName, school, gradeLevel, partcipateInProg, studentTypeid, otherSchoolName, meds, medicalConditions,
                                                                speiclaNeeds, rideBusAlone, signOut, walkHomeAlone, rideBikeAlone, signOuByGuardOnly, caseMrgPersonid);

        }

        /// <summary>
        /// </summary>
        /// <param name="key"></param>
        /// <param name="personTypeID"></param>
        /// <param name="communityid"></param>
        /// <param name="statustypeid"></param>
        /// <param name="countyid"></param>
        /// <param name="djjnum"></param>
        /// <param name="firstname"></param>
        /// <param name="lastname"></param>
        /// <param name="middlename"></param>
        /// <param name="email"></param>
        /// <param name="title"></param>
        /// <param name="company"></param>
        /// <param name="salutation"></param>
        /// <param name="honor"></param>
        /// <param name="genderid"></param>
        /// <param name="dob"></param>
        /// <param name="primLanguage"></param>
        /// <param name="secLanguage"></param>
        /// <param name="notes"></param>
        /// <param name="school"></param>
        /// <param name="gradeLevel"></param>
        /// <param name="partcipateInProg"></param>
        /// <param name="studentTypeid"></param>
        /// <param name="otherSchoolName"></param>
        /// <param name="meds"></param>
        /// <param name="medicalConditions"></param>
        /// <param name="speiclaNeeds"></param>
        /// <param name="insurance"></param>
        /// <param name="insuranceNum"></param>
        /// <param name="rideBusAlone"></param>
        /// <param name="signOut"></param>
        /// <param name="walkHomeAlone"></param>
        /// <param name="rideBikeAlone"></param>
        /// <param name="signOuByGuardOnly"></param>
        /// <param name="releaseOther"></param>
        /// <param name="releaseOtherText"></param>
        /// <param name="caseMrgPersonid"></param>
        /// <returns></returns>
        public static int AddUpdateStudentInfo(int personid, int? locid, int? communityid, int statustypeid, int? countyid, string djjnum, string firstname, string lastname,
                                         string middlename, string email, string title, string company, string salutation, string honor, int? genderid,
                                             DateTime? dob, string primLanguage, string secLanguage, string notes, string school, string gradeLevel, bool? partcipateInProg, int studentTypeid, string otherSchoolName, string meds, string medicalConditions, string speiclaNeeds,
                                                 bool rideBusAlone, bool signOut, bool walkHomeAlone, bool rideBikeAlone, bool signOuByGuardOnly, int? caseMrgPersonid,
                                    bool? signatureRelease, DateTime? releaseSignDate, bool? medicalRelease, DateTime? medReleaseDate,
                                                bool? prodigyRelease, DateTime? prodigyReleaseDate, bool? grievanceSignature, DateTime? grievanceSignatureDate, bool ProgramEligibilityToolCompleted,
                                    string youthParentalStatus, string familyStatus, string referredByList, string referredByOther, string studentId, string Last4SSN)
        {
            return POD.Data.PeopleData.AddUpdateStudentInfo(personid, locid, communityid, statustypeid, countyid, djjnum, firstname, lastname,
                                          middlename, email, title, company, salutation, honor, genderid, dob, primLanguage, secLanguage, notes,
                                          Security.GetCurrentUserProfile().UserName, school, gradeLevel, partcipateInProg, studentTypeid, otherSchoolName, meds, medicalConditions, speiclaNeeds,
                                                 rideBusAlone, signOut, walkHomeAlone, rideBikeAlone, signOuByGuardOnly, caseMrgPersonid, signatureRelease, releaseSignDate
                                                , medicalRelease, medReleaseDate, prodigyRelease, prodigyReleaseDate, grievanceSignature, grievanceSignatureDate, ProgramEligibilityToolCompleted,
                                                youthParentalStatus, familyStatus, referredByList, referredByOther, studentId, Last4SSN);

        }

        public static int AddUpdateStudentInfo(int personid, int? locid, int? communityid, int statustypeid, int? countyid, string djjnum, string firstname, string lastname,
            string middlename, string email, string title, string company, string salutation, string honor, int? genderid,
            DateTime? dob, string primLanguage, string secLanguage, string notes, string school, string gradeLevel, bool? partcipateInProg, int studentTypeid, string otherSchoolName, string meds, string medicalConditions, string speiclaNeeds,
             bool rideBusAlone, bool signOut, bool walkHomeAlone, bool rideBikeAlone, bool signOuByGuardOnly, int? caseMrgPersonid,
            bool? signatureRelease, DateTime? releaseSignDate, bool? medicalRelease, DateTime? medReleaseDate,
            bool? prodigyRelease, DateTime? prodigyReleaseDate, bool? grievanceSignature, DateTime? grievanceSignatureDate, bool ProgramEligibilityToolCompleted,
            string youthParentalStatus, string familyStatus, string referredByList, string referredByOther, string studentId, string Last4SSN, bool? isLunchReduced, bool? isFoster, bool? isMedicaid, bool? liabilityConsent, bool? grievanceConsent, bool? emergencyConsent, bool? isAssessmentok, bool? isMediaCaptureOk, bool? isAuthorizedStaffOk, bool? isDjjYouth)
        {
            return POD.Data.PeopleData.AddUpdateStudentInfo(personid, locid, communityid, statustypeid, countyid, djjnum, firstname, lastname,
                middlename, email, title, company, salutation, honor, genderid, dob, primLanguage, secLanguage, notes,
                Security.GetCurrentUserProfile().UserName, school, gradeLevel, partcipateInProg, studentTypeid, otherSchoolName, meds, medicalConditions, speiclaNeeds,
                 rideBusAlone, signOut, walkHomeAlone, rideBikeAlone, signOuByGuardOnly, caseMrgPersonid, signatureRelease, releaseSignDate
                , medicalRelease, medReleaseDate, prodigyRelease, prodigyReleaseDate, grievanceSignature, grievanceSignatureDate, ProgramEligibilityToolCompleted,
                youthParentalStatus, familyStatus, referredByList, referredByOther, studentId, Last4SSN, isLunchReduced, isFoster, isMedicaid, liabilityConsent, grievanceConsent, emergencyConsent, isAssessmentok, isMediaCaptureOk, isAuthorizedStaffOk, isDjjYouth);

        }

        /// <summary>
        /// adds a person or updates person record
        /// </summary>
        /// <param name="key"></param>
        /// <param name="lastname"></param>
        /// <param name="middlename"></param>
        /// <param name="email"></param>
        /// <returns></returns>
        public static Person AddUpdatePerson(int? key, string firstname, string lastname,
                                         string middlename, string email)
        {

            return POD.Data.PeopleData.AddUpdatePerson(key, firstname, lastname,
                                            middlename, email, Security.GetCurrentUserProfile().UserName);
        }
        /// <summary>
        /// adds a person or updates person record
        /// </summary>
        /// <returns></returns>
        public static Person AddUpdatePerson(int? key, string firstname, string lastname,
                                         string middlename, DateTime? dob, string email, int statusid, int typeid)
        {
            return POD.Data.PeopleData.AddUpdatePerson(key, firstname, lastname,
                                               middlename, dob, email, statusid, typeid, Security.GetCurrentUserProfile().UserName);
        }

        public static IEnumerable<Person> GetAllPeople(string searchText)
        {
            return POD.Data.PeopleData.GetAllPeople(searchText);
        }
        /// <summary>
        /// adds a person or updates person record
        /// </summary>
        /// <param name="key"></param>
        /// <param name="lastname"></param>
        /// <param name="middlename"></param>
        /// <param name="email"></param>
        /// <returns></returns>
        public static Person AddUpdatePerson(int? key, string firstname, string lastname,
                                         string middlename, DateTime? dob)
        {

            return POD.Data.PeopleData.AddUpdatePerson(key, firstname, lastname,
                                            middlename, dob, Security.GetCurrentUserProfile().UserName);
        }
        /// <summary>
        /// adds a person or updates person record
        /// </summary>
        /// <param name="key"></param>
        /// <param name="lastname"></param>
        /// <param name="middlename"></param>
        /// <param name="email"></param>
        /// <returns></returns>
        public static Person AddUpdatePerson(int? key, string firstname, string lastname,
                                         string middlename, DateTime? dob, int typeid, string djjnum, int? siteid)
        {

            return POD.Data.PeopleData.AddUpdatePerson(key, firstname, lastname,
                                            middlename, dob, typeid, djjnum, siteid, Security.GetCurrentUserProfile().UserName);
        }
        /// <summary>
        /// adds a person or updates person record
        /// </summary>
        /// <param name="key"></param>
        /// <param name="personTypeID"></param>
        /// <param name="communityid"></param>
        /// <param name="statustypeid"></param>
        /// <param name="countyid"></param>
        /// <param name="djjnum"></param>
        /// <param name="firstname"></param>
        /// <param name="lastname"></param>
        /// <param name="middlename"></param>
        /// <param name="email"></param>
        /// <param name="title"></param>
        /// <param name="company"></param>
        /// <param name="salutation"></param>
        /// <param name="honor"></param>
        /// <param name="genderid"></param>
        /// <param name="dob"></param>
        /// <param name="primLanguage"></param>
        /// <param name="secLanguage"></param>
        /// <param name="notes"></param>
        /// <returns></returns>
        public static Person AddUpdateStudent(int? key, string firstname, string lastname,
                                         string middlename, DateTime? dob)
        {
            return POD.Data.PeopleData.AddUpdateStudent(key, firstname, lastname,
                                      middlename, dob, Security.GetCurrentUserProfile().UserName);
        }
        /// <summary>
        /// marks the person record to deleted
        /// </summary>
        /// <param name="key"></param>
        /// <returns></returns>
        public static string DeletePerson(int key)
        {
            return POD.Data.PeopleData.DeletePerson(key);
        }

        /// <summary>
        /// person object with all related information
        /// included in selection
        /// </summary>
        /// <param name="key">identifier</param>
        /// <returns></returns>
        public static Person GetPersonAndRelatedInfoByID(int key)
        {
            return (Person)POD.Data.PeopleData.GetPersonAndRelatedInfoByID(key);
        }

        /// <summary>
        /// student object with all related information
        /// included in selection
        /// </summary>
        /// <param name="key">identifier</param>
        /// <returns></returns>
        public static Student GetStudentAndRelatedInfoByID(int key)
        {
            return POD.Data.PeopleData.GetPersonAndRelatedInfoByID(key) as Student;
        }

        /// <summary>
        /// this gets person audit record if exist
        /// is included
        /// </summary>
        /// <param name="key">identifier</param>
        /// <returns></returns>
        public static Persons_Audit GetPersonAudit(int key)
        {
            return POD.Data.PeopleData.GetPersonAudit(key);
        }
        /// <summary>
        /// this gets possible people matches
        /// based on name and dob
        /// </summary>
        /// <param name="key">indetifier</param>
        /// <returns></returns>
        public static List<Person> GetPeopleByNameMatch(string firstname, string lastname, DateTime? dob)
        {
            using (PODContext context = new PODContext())
            {
                return POD.Data.PeopleData.GetPeopleByNameMatch(firstname, lastname, dob);
            }
        }
        /// <summary>
        /// this gets possible people matches counts
        /// based on name and dob
        /// </summary>
        /// <param name="key">indetifier</param>
        /// <returns></returns>
        public static int GetPeopleByNameMatchCount(string firstname, string lastname, DateTime? dob)
        {
            return POD.Data.PeopleData.GetPeopleByNameMatchCount(firstname, lastname, dob);
        }

        /// <summary>
        /// this gets possible people matches
        /// based on name and dob
        /// </summary>
        /// <param name="key">indetifier</param>
        /// <returns></returns>
        public static List<Person> GetPeopleByNameMatch(string firstname, string lastname)
        {
            using (PODContext context = new PODContext())
            {
                return POD.Data.PeopleData.GetPeopleByNameMatch(firstname, lastname);
            }
        }

        /// <summary>
        /// this only gets person object no related information
        /// is included
        /// </summary>
        /// <param name="key">indetifier</param>
        /// <returns></returns>
        public static Person GetPersonByID(int key)
        {
            return (Person)POD.Data.PeopleData.GetPersonByID(key);
        }

        /// <summary>
        /// this only gets staff member  object 
        /// /// </summary>
        /// <param name="key">identifier</param>
        /// <returns></returns>
        public static StaffMember GetStaffByUserID(Guid key)
        {
            return POD.Data.PeopleData.GetStaffByUserID(key);
        }

        public static Person GetStaffByUserName(string username)
        {
            return POD.Data.PeopleData.GetStaffByUserName(username);
        }
        /// <summary>
        /// gets all related people by type
        /// is included
        /// </summary>
        /// <param name="key">identifier</param>
        /// <param name="relationTypekey">relationship type identifer</param>
        /// <returns></returns>
        public static IEnumerable<Person> GetPersonsByRelationTypeAndID(int key, int relationtypekey)
        {
            return POD.Data.PeopleData.GetPersonsByRelationTypeAndID(key, relationtypekey);
        }

        /// <summary>
        /// gets all related people for person
        /// is included
        /// </summary>
        /// <param name="key">identifier</param>
        /// <returns></returns>
        public static IEnumerable<Person> GetRelatedPersonsByID(int key)
        {
            return POD.Data.PeopleData.GetRelatedPersonsByID(key);
        }

        /// <summary>
        /// gets related people that are guardians
        /// </summary>
        /// <param name="key">identifier</param>
        /// <returns></returns>
        public static IList<Person> GetGuardiansByID(int key)
        {
            return POD.Data.PeopleData.GetGuardiansByID(key);
        }

        /// <summary>
        /// gets related people that are emergency contacts
        /// </summary>
        /// <param name="key">identifier</param>
        /// <returns></returns>
        public static IList<Person> GetEmergencyContactsByID(int key)
        {
            return POD.Data.PeopleData.GetEmergencyContactsByID(key);
        }

        /// <summary>
        /// gets related people that are authorized to pick up 
        /// </summary>
        /// <param name="key">identifier</param>
        /// <returns></returns>
        public static IEnumerable<Person> GetAuthorizedPeopleByID(int key)
        {
            return POD.Data.PeopleData.GetAuthorizedToPickupPeopleByID(key);
        }

        public static IList<Person> GetAuthorizedPeopleByID_New(int key)
        {
            return POD.Data.PeopleData.GetAuthorizedToPickupPeopleByID_New(key);
        }

        public static IEnumerable<Person> GetAuthorizedWithoutGuardiansToPickupPeopleByID(int key)
        {
            return POD.Data.PeopleData.GetAuthorizedWithoutGuardiansToPickupPeopleByID(key);
        }

        public static string DeleteContacts(int personid, int erPersonid, string type)
        {
            if (type == "ER")
            {
                return POD.Data.PeopleData.DeleteEmergencyContacts(personid, erPersonid);
            }
            else if (type == "AU")
            {
                return POD.Data.PeopleData.DeleteAutorizedContacts(personid, erPersonid);
            }
            else
            {
                return POD.Data.PeopleData.DeletePhysicianContacts(personid, erPersonid);
            }
        }

        public static string DeleteEnrollmentNote(int enrollmentNoteId)
        {
            return POD.Data.PeopleData.DeleteEnrollmentNote(enrollmentNoteId);
        }

        /// <summary>
        /// gets all docotors  for a person
        /// </summary>
        /// <param name="key">identifier</param>
        /// <returns></returns>
        public static IList<Person> GetDoctorsByID(int personID)
        {
            return POD.Data.PeopleData.GetDoctorsByID(personID);
        }


        /// <summary>
        /// gets all students that are active
        /// </summary>
        /// <returns>list</returns>
        public static IList<Student> GetStudents()
        {
            return POD.Data.PeopleData.GetStudents();
        }

        public static IEnumerable<Student> GetStudents(int siteid)
        {
            return POD.Data.PeopleData.GetStudents(siteid);
        }
        /// <summary>
        /// gets allstaff members for location or all
        /// </summary>
        /// <param name="key">location identifier</param>
        /// <returns>list</returns>
        public static List<StaffMember> GetStaff(int? siteID = null)
        {
            return POD.Data.PeopleData.GetStaff(siteID).OrderBy(c => c.LastName).ThenBy(c => c.FirstName).ToList();
        }

        /// <summary>
        ///counts attendance hours and determines eligibility for certificate
        /// </summary>
        /// <returns>list</returns>
        public static bool GetStudentEligibleForCertificate(int personid, int enrollmentid, int riskID)
        {
            return POD.Data.PeopleData.GetStudentEligibleForCertificate(personid, enrollmentid, riskID);
        }

        /// <summary>
        /// person search
        /// </summary>
        /// <param name="name"></param>
        /// <param name="guardian"></param>
        /// <param name="zip"></param>
        /// <param name="school"></param>
        /// <param name="type"></param>
        /// <param name="status"></param>
        /// <param name="startDate"></param>
        /// <param name="endDate"></param>
        /// <param name="races"></param>
        /// <returns></returns>
        public static List<sp_GetPersonEnrollments_Result> GetPersonBySearch(int programid, int? siteid, int? grantYearid, string name, string guardian, string zip, string school, int? type, int? status, DateTime? startDate, DateTime? endDate, string races, string djjNum)
        {
            if (grantYearid == null)
            {
                grantYearid = ManageTypesLogic.GetCurrentGrantYearID();
            }
            return POD.Data.PeopleData.GetPersonBySearch(programid, siteid, grantYearid, name, guardian, zip, school, type, status, startDate, endDate, races, djjNum);
        }

        public static List<sp_GetPersonEnrollments2_Result> GetPersonBySearch(int programid, int? siteid, int? grantYearid, string name, string guardian, string zip, string school, int? type, int? status, DateTime? startDate, DateTime? endDate, string races, string djjNum, string isdjjyouth)
        {
            if (grantYearid == null)
            {
                grantYearid = ManageTypesLogic.GetCurrentGrantYearID();
            }
            return POD.Data.PeopleData.GetPersonBySearch(programid, siteid, grantYearid, name, guardian, zip, school, type, status, startDate, endDate, races, djjNum, isdjjyouth);
        }
        /// <summary>
        /// people for bulkedit
        /// </summary>
        ///<param name="programid">Program Identifier</param>
        ///<param name="enrollmentTypeID">Enrollment Type ID</param>
        ///<param name="noAttendance">no attendance in the last 90 days</param>
        ///<param name="rollOver">rollover classes for grant year</param>
        /// <returns></returns>
        public static List<BulkEditStudents_Result> GetYouthBulkEdit(int programid, int? siteid, int? enrollmentTypeID, bool? noAttendance, bool? rollOver)
        {
            return POD.Data.PeopleData.GetYouthBulkEdit(programid, siteid, enrollmentTypeID, noAttendance, rollOver);

        }
        public static List<sp_ReleasedYouthByDate_Result> GetReleasedYouthByDate( DateTime? releaseDate, int? siteid)
        {
            return POD.Data.PeopleData.GetReleasedYouthByDate(releaseDate, siteid);
        }

        /// <summary>
        /// people for bulkedit
        /// </summary>
        ///<param name="programid">Program Identifier</param>
        ///<param name="enrollmentTypeID">Enrollment Type ID</param>
        ///<param name="noAttendance">no attendance in the last 90 days</param>
        ///<param name="rollOver">rollover classes for grant year</param>
        /// <returns></returns>
        public static List<sp_GetPersonForBulkRelease_Result> GetYouthBulkEdit(int programid, int? siteid, int? enrollmentTypeID, bool? noAttendance, bool? rollOver, int? GrantYearid, int? YouthTypeid)
        {
            return POD.Data.PeopleData.GetYouthBulkRelease(programid, siteid, enrollmentTypeID, noAttendance, rollOver, GrantYearid, YouthTypeid);
        }

        /// <summary>
        /// adds existing ethnicities to person record
        /// 
        /// </summary>
        /// <param name="key">Person ID</param>
        /// <param name="ethnicityKeyList">Ethnicities Identifiers</param>
        /// <returns></returns>
        public static string AddEthnicityToPerson(int key, List<int> ethnicityKeyList)
        {
            return POD.Data.PeopleData.AddEthnicityToPerson(key, ethnicityKeyList);
        }

        /// <summary>
        /// adds existing addresses to person record
        /// </summary>
        /// <param name="key">Person Identifier</param>
        /// <param name="addresskeyList">list of addresses</param>
        /// <returns></returns>
        public static string AddAddressToPerson(int key, List<int> addresskeyList)
        {
            return POD.Data.PeopleData.AddAddressToPerson(key, addresskeyList);
        }

        /// <summary>
        /// adds existing addresses to person record
        /// </summary>
        /// <param name="key">Person Identifier</param>
        /// <param name="addresskeyList">list of addresses</param>
        /// <returns></returns>
        public static string AddSchoolAddressToPerson(int key, int addresskey)
        {
            return POD.Data.PeopleData.AddSchoolAddressToStudent(key, addresskey);
        }

        /// <summary>
        /// removes existing addresses from person record
        /// </summary>
        /// <param name="key">Person Identifier</param>
        /// <param name="addresskeyList">list of addresses</param>
        /// <returns></returns>
        public static string DeleteAddressFromPerson(int key, int addresskey)
        {
            return POD.Data.PeopleData.DeleteAddressFromPerson(key, addresskey);
        }

        /// <summary>
        /// adds existing phone numbers to person record
        /// </summary>
        /// <param name="key">Person Identifier</param>
        /// <param name="addresskeyList">list of phone numbers</param>
        /// <returns></returns>
        public static string AddPhoneNumbersToPerson(int key, List<int> numberskeyList)
        {
            return POD.Data.PeopleData.AddPhoneNumbersToPerson(key, numberskeyList);
        }

        /// <summary>
        /// removes existing phone number from person record
        /// </summary>
        /// <param name="key">Person Identifier</param>
        /// <param name="addresskeyList">list of addresses</param>
        /// <returns></returns>
        public static string DeletePhoneNumberFromPerson(int key, int phoneID)
        {
            return POD.Data.PeopleData.DeletePhoneNumberFromPerson(key, phoneID);
        }
        /// <summary>
        /// adds existing Races to person record
        /// </summary>
        /// <param name="key">Person ID</param>
        /// <param name="ethnicityKeyList">Races Identifiers</param>
        /// <returns></returns>
        public static string AddRacesToPerson(int key, List<int> racesKeyList)
        {
            return POD.Data.PeopleData.AddRacesToPerson(key, racesKeyList);
        }

        /// <summary>
        /// adds locations to person record
        /// </summary>
        /// <param name="key">Person ID</param>
        /// <param name="locationId">Location ID</param>
        /// <returns></returns>
        public static string SetLocationForPerson(int key, int locationId)
        {
            return POD.Data.PeopleData.SetLocationForPerson(key, locationId);
        }

        /// <summary>
        /// adds existing Course Instances to person record
        /// </summary>
        /// <param name="key">Person ID</param>
        /// <param name="ethnicityKeyList">course Identifiers</param>
        /// <returns></returns>
        public static string AddCourseInstancesToPerson(int key, List<int> coursesInstanceKeyList)
        {
            return POD.Data.PeopleData.AddCourseInstancesToPerson(key, coursesInstanceKeyList);
        }

        /// <summary>
        /// add person relationship
        /// always set to active
        /// </summary>
        /// <param name="personid">Person ID</param>
        /// <param name="relatedpersonid">Related Person ID</param>
        /// <param name="relationshiptypeid">Relationship Type ID</param>
        /// <returns></returns>
        public static string AddPersonRelationShip(int personid, int relatedpersonid, int relationshiptypeid, string relationshipOther, bool isGuardian, bool isER, bool isAuthorized, bool isPhysician)
        {
            return POD.Data.PeopleData.AddPersonRelationShip(personid, relatedpersonid, relationshiptypeid, relationshipOther, isGuardian, isER, isAuthorized, isPhysician);
        }
        /// <summary>
        /// add person relationship
        /// always set to active
        /// </summary>
        /// <param name="personid">Person ID</param>
        /// <param name="relatedpersonid">Related Person ID</param>
        /// <param name="relationshiptypeid">Relationship Type ID</param>
        /// <returns></returns>
        public static string AddGuardianRelationShip(int personid, int relatedpersonid, int relationshiptypeid, string relationshipOther, bool isEmergencyContact)
        {
            return POD.Data.PeopleData.AddPersonRelationShip(personid, relatedpersonid, relationshiptypeid, relationshipOther, true, isEmergencyContact, false, false);
        }

        public static string DeleteGuardianRelationShip(int key)
        {
            return POD.Data.PeopleData.DeletePersonRelationship(key);
        }

        /// <summary>
        /// add person relationship
        /// always set to active
        /// </summary>
        /// <param name="personid">Person ID</param>
        /// <param name="relatedpersonid">Related Person ID</param>
        /// <param name="relationshiptypeid">Relationship Type ID</param>
        /// <returns></returns>
        public static string AddERRelationShip(int personid, int relatedpersonid, int relationshiptypeid, string relationshipOther)
        {
            return POD.Data.PeopleData.AddPersonRelationShip(personid, relatedpersonid, relationshiptypeid, relationshipOther, false, true, false, false);
        }

        /// <summary>
        /// add person relationship
        /// always set to active
        /// </summary>
        /// <param name="personid">Person ID</param>
        /// <param name="relatedpersonid">Related Person ID</param>
        /// <param name="relationshiptypeid">Relationship Type ID</param>
        /// <returns></returns>
        public static string AddAuthorizedRelationShip(int personid, int relatedpersonid, int relationshiptypeid, string relationshipOther)
        {
            return POD.Data.PeopleData.AddPersonRelationShip(personid, relatedpersonid, relationshiptypeid, relationshipOther, false, false, true, false);
        }

        public static string UpdatePersonLocation(int personid, int locationid)
        {
            return POD.Data.PeopleData.UpdatePersonLocation(personid, locationid, Security.GetCurrentUserProfile().UserName);
        }

        #region DJJ Import
        /// <summary>
        /// returns list of non staff with no djjnum assigned yet
        /// </summary>
        /// <returns></returns>
        public static List<Person> GetPRefilteredDJJNumPossibleMatches()
        {
            return POD.Data.PeopleData.GetPRefilteredDJJNumPossibleMatches();
        }

        /// <summary>
        /// this gets possible people matches
        /// based on name and dob
        /// </summary>
        /// <param name="key">indetifier</param>
        /// <returns></returns>
        public static List<Person> GetYouthWithNoDJJByNameMatch(List<Person> people, string firstname, string lastname, string middle, DateTime? dob)
        {
            List<Person> matches = people.Where(p => p.FirstName != null && p.LastName != null && p.FirstName.ToLower() == firstname.ToLower() && p.LastName.ToLower() == lastname.ToLower() &&
                       (middle == string.Empty || p.MiddleName == null || (p.MiddleName != null && p.MiddleName.Contains(middle.ToLower())) || (p.MiddleName != null && p.MiddleName.ToLower() == middle.ToLower())) && (!dob.HasValue || !p.DateOfBirth.HasValue || (dob.HasValue && p.DateOfBirth.HasValue && p.DateOfBirth.Value.Date == dob.Value.Date))).ToList();
            return matches;

        }
        /// <summary>
        /// update youths djj number
        /// </summary>
        /// <param name="youthList"></param>
        /// <returns></returns>
        public static string UpdateYouthsDJJNumberandEnrollmentStatus(List<ImportPerson> youthList)
        {
            return POD.Data.PeopleData.UpdateYouthsDJJNumberandEnrollmentStatus(youthList);
        }
        #endregion

        #region Staff
        /// <summary>
        /// gets all staff members
        /// </summary>
        /// <param name="key"></param>
        /// <returns></returns>
        public static List<StaffMember> GetAllStaff()
        {
            return POD.Data.PeopleData.GetAllStaff();
        }
        /// <summary>
        /// gets all staff members by site
        /// </summary>
        /// <param name="key"></param>
        /// <returns></returns>
        public static List<StaffMember> GetAllStaff(int? siteID)
        {

            return POD.Data.PeopleData.GetAllStaff(siteID);

        }

        /// <summary>
        /// gets site id for staff member
        /// </summary>
        /// <param name="key"></param>
        /// <returns></returns>
        public static int GetSiteIDForStaff(int key)
        {
            return POD.Data.PeopleData.GetSiteIDForStaff(key);
        }
        /// <summary>
        /// gets staff by id
        /// </summary>
        /// <param name="key"></param>
        /// <returns></returns>
        public static StaffMember GetStaffByID(int key)
        {
            return POD.Data.PeopleData.GetStaffByID(key) as StaffMember;
        }

        /// <summary>
        /// deletes associated lesson plans 
        /// updates classes and course instances
        /// deletes the staff and person record
        /// 
        /// </summary>
        /// <param name="key"></param>
        /// <returns></returns>
        public static string DeleteStaff(int key)
        {
            return POD.Data.PeopleData.DeleteStaff(key, Security.GetCurrentUserProfile().UserName);
        }

        /// <summary>
        /// creates or udpates the staff member 
        /// </summary>
        /// <param name="key"></param>
        /// <returns></returns>
        public static int AddUpdateStaff(int key, int personTypeID, int statustypeid, string firstname, string lastname, string middlename, string email, string title, string company,
                                                        string salutation, int? genderid, DateTime? dob, Guid userid, bool isActive, bool isAdmin, int? locid, DateTime? hiredate, DateTime? endDate)
        {
            return POD.Data.PeopleData.AddUpdateStaff(key, personTypeID, statustypeid, firstname, lastname, middlename, email, title, company, salutation, genderid, dob, userid, isActive, isAdmin, locid, hiredate, endDate,
                        Security.GetCurrentUserProfile().UserName);
        }
        public static int AddUpdateStaff(int key, int personTypeID, string firstname, string lastname, string middlename, string email, string title, string company,
                                                       string salutation, int? genderid, DateTime? dob, Guid userid, int? locid)
        {
            return POD.Data.PeopleData.AddUpdateStaff(key, personTypeID, firstname, lastname, middlename, email, title, company, salutation, genderid, dob, userid, locid,
                            Security.GetCurrentUserProfile().UserName);
        }
        public static string UpdateUserName(Guid userid, string username)
        {
            return POD.Data.PeopleData.UpdateUserName(userid, username);
        }
        #endregion

        #region Staff Positions

        public static int AddUpdatePosition(int key, bool isOpen, int? locationId, int programId, int? personId, string jobTitle, DateTime? vacancyDate)
        {
            return POD.Data.PeopleData.AddUpdatePosition(
                key,
                isOpen,
                locationId,
                programId,
                personId,
                jobTitle,
                vacancyDate,
                Security.GetCurrentUserProfile().UserName);
        }

        public static List<Position> GetPositionsBySearch(
            int? locationId = null,
            int? programId = null,
            int? personId = null)
        {
            return POD.Data.PeopleData.GetPositionsBySearch(locationId, programId, personId);
        }

        public static Position GetPositionByID(int id)
        {
            return POD.Data.PeopleData.GetPositionByID(id);
        }

        public static bool DeletePosition(int id, out string message)
        {
            return POD.Data.PeopleData.DeletePosition(id, out message);
        }

        #endregion

        public static void SetEnrollmentDateGraduated(int enrollmentId, DateTime date)
        {
            POD.Data.EnrollmentData.SetEnrollmentDateGraduated(enrollmentId, date);
        }
    }
}
