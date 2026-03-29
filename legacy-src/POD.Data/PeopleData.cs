using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Data.Entity;
using System.Linq.Expressions;
using System.Text;
using System.Xml.Serialization;
using POD.Data.Entities;
using POD.Logging;

namespace POD.Data
{
	public static class PeopleData
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
		/// <param name="ssn"></param>
		/// <param name="dob"></param>
		/// <param name="primLanguage"></param>
		/// <param name="secLanguage"></param>
		/// <param name="notes"></param>
		/// <returns></returns>
		public static int AddUpdatePerson(int? key, int personTypeID, int? communityid, int statustypeid, int? countyid, string djjnum, string firstname, string lastname,
										 string middlename, string email, string title, string company, string salutation, string honor, int? genderid,
											 DateTime? dob, string primLanguage, string secLanguage, string notes, string currentUserName)
		{
			int personKey = 0;
			bool isAdd = false;
			using (PODContext context = new PODContext())
			{
				try
				{
					Person originalPerson = null;

					if (key.HasValue)
					{
						originalPerson = context.Persons.FirstOrDefault(p => p.PersonID == key.Value);
						personKey = key.Value;
					}
					if (originalPerson == null)
					{
						isAdd = true;
						originalPerson = new Person();
						originalPerson.rowguid = Guid.NewGuid();
						personKey = originalPerson.PersonID;
						originalPerson.DateTimeStamp = DateTime.Now;

					}
					//set all properties
					originalPerson.PersonTypeID = personTypeID;

					originalPerson.CommunityID = communityid;
					//status
					originalPerson.StatusTypeID = statustypeid;
					originalPerson.GenderID = genderid;
					originalPerson.CountyID = countyid;
					originalPerson.DJJIDNum = djjnum;
					originalPerson.FirstName = firstname.Substring(0, 1).ToUpper() + firstname.Substring(1);
					originalPerson.LastName = lastname.Substring(0, 1).ToUpper() + lastname.Substring(1);
					originalPerson.MiddleName = !string.IsNullOrEmpty(middlename) ? middlename.Substring(0, 1).ToUpper() + middlename.Substring(1) : string.Empty;
					originalPerson.Email = email;
					originalPerson.Title = title;
					originalPerson.CompanyName = company;
					originalPerson.Salutation = salutation;
					originalPerson.Honorific = honor;
					originalPerson.DateOfBirth = dob;
					originalPerson.PrimaryLanguageSpoken = primLanguage;
					originalPerson.OtherLanguagesSpoken = secLanguage;
					originalPerson.Notes = notes;
					originalPerson.LastModifiedBy = currentUserName;//always set
					if (isAdd)
					{
						context.Persons.AddObject(originalPerson);
					}

					context.SaveChanges();
					personKey = originalPerson.PersonID;

				}
				catch (Exception ex)
				{
					ex.Log();
				}
			}

			return personKey;
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
		/// <param name="ssn"></param>
		/// <param name="dob"></param>
		/// <param name="primLanguage"></param>
		/// <param name="secLanguage"></param>
		/// <param name="notes"></param>
		/// <returns></returns>
		public static Person AddUpdatePerson(int? key, string firstname, string lastname,
										 string middlename, string email, string currentUserName)
		{
			Person pers = null;
			bool isAdd = false;
			using (PODContext context = new PODContext())
			{
				try
				{
					Person originalPerson = null;

					if (key.HasValue && key.Value != 0)
					{
						originalPerson = context.Persons.FirstOrDefault(p => p.PersonID == key.Value);
					}
					//try match by first name last name and email match
					//if (originalPerson == null)
					//{
					//    originalPerson = context.Persons.FirstOrDefault(p => p.LastName.ToLower() == lastname.ToLower() && p.FirstName.ToLower() == firstname.ToLower());
					//}
					if (originalPerson == null)
					{
						isAdd = true;
						originalPerson = new Person();
						originalPerson.rowguid = Guid.NewGuid();
						originalPerson.DateTimeStamp = DateTime.Now;
						PersonType newPersonType = context.PersonTypes.FirstOrDefault(t => t.Name.ToLower().Contains("non-student"));
						originalPerson.PersonType = newPersonType;
					}

					//status
					StatusType newStatus = context.StatusTypes.FirstOrDefault(c => c.Name.ToLower().Contains("active"));
					originalPerson.StatusType = newStatus;
					originalPerson.FirstName = firstname.Substring(0, 1).ToUpper() + firstname.Substring(1);
					originalPerson.LastName = lastname.Substring(0, 1).ToUpper() + lastname.Substring(1);
					originalPerson.MiddleName = !string.IsNullOrEmpty(middlename) ? middlename.Substring(0, 1).ToUpper() + middlename.Substring(1) : string.Empty;

					originalPerson.Email = email;

					originalPerson.LastModifiedBy = currentUserName;//always set
					if (isAdd)
					{
						context.Persons.AddObject(originalPerson);
					}

					context.SaveChanges();
					pers = context.Persons.Include(x => x.Addresses.Select(a => a.AddressType)).Include(x => x.PhoneNumbers.Select(p => p.PhoneNumberType)).FirstOrDefault(pp => pp.PersonID == originalPerson.PersonID);

				}
				catch (Exception ex)
				{
					ex.Log();
				}
			}

			return pers;
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
		/// <param name="ssn"></param>
		/// <param name="dob"></param>
		/// <param name="primLanguage"></param>
		/// <param name="secLanguage"></param>
		/// <param name="notes"></param>
		/// <returns></returns>
		public static Person AddUpdatePerson(int? key, string firstname, string lastname,
										 string middlename, DateTime? dob, string currentUserName)
		{
			Person pers = null;
			bool isAdd = false;
			using (PODContext context = new PODContext())
			{
				try
				{
					Person originalPerson = null;

					if (key.HasValue && key.Value != 0)
					{
						originalPerson = context.Persons.FirstOrDefault(p => p.PersonID == key.Value);
					}
					if (originalPerson == null)
					{
						isAdd = true;
						originalPerson = new Person();
						originalPerson.rowguid = Guid.NewGuid();
						originalPerson.DateTimeStamp = DateTime.Now;
						PersonType newPersonType = context.PersonTypes.FirstOrDefault(t => t.Name.ToLower().Contains("student"));
						originalPerson.PersonType = newPersonType;
					}

					//status
					StatusType newStatus = context.StatusTypes.FirstOrDefault(c => c.Name.ToLower().Contains("active"));
					originalPerson.StatusType = newStatus;
					originalPerson.FirstName = firstname.Substring(0, 1).ToUpper() + firstname.Substring(1);
					originalPerson.LastName = lastname.Substring(0, 1).ToUpper() + lastname.Substring(1);
					originalPerson.MiddleName = !string.IsNullOrEmpty(middlename) ? middlename.Substring(0, 1).ToUpper() + middlename.Substring(1) : string.Empty;

					originalPerson.DateOfBirth = dob;

					originalPerson.LastModifiedBy = currentUserName;//always set
					if (isAdd)
					{
						context.Persons.AddObject(originalPerson);
					}

					context.SaveChanges();
					pers = context.Persons.Include(x => x.Addresses.Select(a => a.AddressType)).Include(x => x.PhoneNumbers.Select(p => p.PhoneNumberType)).FirstOrDefault(pp => pp.PersonID == originalPerson.PersonID);

				}
				catch (Exception ex)
				{
					ex.Log();
				}
			}

			return pers;
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
		/// <param name="ssn"></param>
		/// <param name="dob"></param>
		/// <param name="primLanguage"></param>
		/// <param name="secLanguage"></param>
		/// <param name="notes"></param>
		/// <returns></returns>
		public static Person AddUpdatePerson(int? key, string firstname, string lastname,
										 string middlename, DateTime? dob, int typeid, string djjnum, int? siteid, string currentUserName)
		{
			Person pers = null;
			bool isAdd = false;
			using (PODContext context = new PODContext())
			{
				try
				{
					Person originalPerson = null;

					if (key.HasValue && key.Value != 0)
					{
						originalPerson = context.Persons.OfType<Student>().Where(w => w.PersonID == key.Value).FirstOrDefault();
					}
					if (originalPerson == null)
					{
						isAdd = true;
						originalPerson = new Student();
						originalPerson.rowguid = Guid.NewGuid();
						originalPerson.DateTimeStamp = DateTime.Now;
						PersonType newPersonType = context.PersonTypes.FirstOrDefault(t => t.Name.ToLower().Contains("student"));
						originalPerson.PersonType = newPersonType;
						originalPerson.LocationID = siteid;
					}
			   
					//status
					StatusType newStatus = context.StatusTypes.FirstOrDefault(c => c.Name.ToLower().Contains("active"));
					originalPerson.StatusType = newStatus;
					originalPerson.FirstName = firstname.Substring(0, 1).ToUpper() + firstname.Substring(1);
					originalPerson.LastName = lastname.Substring(0, 1).ToUpper() + lastname.Substring(1);
					originalPerson.MiddleName = !string.IsNullOrEmpty(middlename) ? middlename.Substring(0, 1).ToUpper() + middlename.Substring(1) : string.Empty;

					originalPerson.DateOfBirth = dob;
					originalPerson.DJJIDNum = djjnum;
					originalPerson.StatusTypeID = typeid;

					originalPerson.LastModifiedBy = currentUserName;//always set
					if (isAdd)
					{
						context.Persons.AddObject(originalPerson);
					}

					context.SaveChanges();
					pers = context.Persons.Include(x => x.Addresses.Select(a => a.AddressType)).Include(x => x.PhoneNumbers.Select(p => p.PhoneNumberType)).FirstOrDefault(pp => pp.PersonID == originalPerson.PersonID);

				}
				catch (Exception ex)
				{
					ex.Log();
				}
			}

			return pers;
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
		/// <param name="ssn"></param>
		/// <param name="dob"></param>
		/// <param name="primLanguage"></param>
		/// <param name="secLanguage"></param>
		/// <param name="notes"></param>
		/// <returns></returns>
		public static Person AddUpdateStudent(int? key, string firstname, string lastname,
										 string middlename, DateTime? dob, string currentUserName)
		{
			Person pers = null;
			bool isAdd = false;
			using (PODContext context = new PODContext())
			{
				try
				{
					Student originalPerson = null;
					if (key.HasValue && key.Value != 0)
					{
						originalPerson = context.Persons.OfType<Student>().Where(w => w.PersonID == key.Value).FirstOrDefault();
					}
					if (originalPerson == null)
					{
						isAdd = true;
						originalPerson = new Student();
						originalPerson.rowguid = Guid.NewGuid();
						originalPerson.DateTimeStamp = DateTime.Now;
						PersonType newPersonType = context.PersonTypes.FirstOrDefault(t => t.Name.ToLower().Contains("student"));
						originalPerson.PersonType = newPersonType;
					}

					//status
					StatusType newStatus = context.StatusTypes.FirstOrDefault(c => c.Name.ToLower().Contains("active"));
					originalPerson.StatusType = newStatus;
					originalPerson.FirstName = firstname.Substring(0, 1).ToUpper() + firstname.Substring(1);
					originalPerson.LastName = lastname.Substring(0, 1).ToUpper() + lastname.Substring(1);
					originalPerson.MiddleName = !string.IsNullOrEmpty(middlename) ? middlename.Substring(0, 1).ToUpper() + middlename.Substring(1) : string.Empty;
					originalPerson.DateOfBirth = dob;

					originalPerson.LastModifiedBy = currentUserName;//always set
					if (isAdd)
					{
						context.Persons.AddObject(originalPerson);
					}

					context.SaveChanges();
					pers = context.Persons.Include(x => x.Addresses.Select(a => a.AddressType)).Include(x => x.PhoneNumbers.Select(p => p.PhoneNumberType)).FirstOrDefault(pp => pp.PersonID == originalPerson.PersonID);

				}
				catch (Exception ex)
				{
					ex.Log();
				}
			}

			return pers;
		}

		/// <summary>
		/// adds a person or updates person record
		/// </summary>
		/// <returns></returns>
		public static Person AddUpdatePerson(int? key, string firstname, string lastname,
										 string middlename, DateTime? dob, string email, int statusid, int typeid, string currentUserName)
		{
			Person pers = null;
			bool isAdd = false;
			using (PODContext context = new PODContext())
			{
				try
				{
					Person originalPerson = null;

					if (key.HasValue && key.Value != 0)
					{
						originalPerson = context.Persons.FirstOrDefault(p => p.PersonID == key.Value);
					}

					//if (originalPerson == null)//try matching non students on first and last name
					//{
					//    originalPerson = context.Persons.FirstOrDefault(p => p.FirstName.ToLower() == firstname.ToLower() && p.LastName.ToLower() == lastname.ToLower() && p.PersonType.Name == "Non-Student");
					//}

					if (originalPerson == null)
					{
						isAdd = true;
						originalPerson = new Person();
						originalPerson.rowguid = Guid.NewGuid();
						originalPerson.DateTimeStamp = DateTime.Now;

					}

					//status
					originalPerson.PersonTypeID = typeid;
					originalPerson.StatusTypeID = statusid;
					originalPerson.Email = email;
					originalPerson.FirstName = firstname.Substring(0, 1).ToUpper() + firstname.Substring(1);
					originalPerson.LastName = lastname.Substring(0, 1).ToUpper() + lastname.Substring(1);
					originalPerson.MiddleName = !string.IsNullOrEmpty(middlename) ? middlename.Substring(0, 1).ToUpper() + middlename.Substring(1) : string.Empty;

					originalPerson.DateOfBirth = dob;

					originalPerson.LastModifiedBy = currentUserName;//always set
					if (isAdd)
					{
						context.Persons.AddObject(originalPerson);
					}

					context.SaveChanges();
					pers = context.Persons.Include(x => x.Addresses.Select(a => a.AddressType)).Include(x => x.PhoneNumbers.Select(p => p.PhoneNumberType)).FirstOrDefault(pp => pp.PersonID == originalPerson.PersonID);

				}
				catch (Exception ex)
				{
					ex.Log();
				}
			}

			return pers;
		}

		/// <summary>
		/// adds student related information
		/// </summary>
		/// <param name="personid"></param>
		/// <param name="school"></param>
		/// <param name="gradeLevel"></param>
		/// <param name="partcipateInProg"></param>
		/// <returns></returns>
		public static int AddUpdateStudentInfo(int personid, int? locid, int? communityid, int statustypeid, int? countyid, string djjnum, string firstname, string lastname,
										 string middlename, string email, string title, string company, string salutation, string honor, int? genderid, 
											 DateTime? dob, string primLanguage, string secLanguage, string notes, string username, string school, string gradeLevel, bool? partcipateInProg, int studentTypeid, string otherSchoolName, string meds, string medicalConditions, string speiclaNeeds,
												 bool rideBusAlone, bool signOut, bool walkHomeAlone, bool rideBikeAlone, bool signOuByGuardOnly,  int? caseMrgPersonid, bool? signatureRelease, DateTime? releaseSignDate, bool? medicalRelease, DateTime? medReleaseDate,
												bool? prodigyRelease, DateTime? prodigyReleaseDate, bool? grievanceSignature, DateTime? grievanceSignatureDate, bool ProgramElibilityToolCompleted,
												string youthParentalStatus, string familyStatus, string referredyByList, string referredByOther, string studentId, string last4SSN)
		{
			int personKey = -1;
			bool isAdd = false;
			using (PODContext context = new PODContext())
			{
				try
				{
					Student student = context.Persons.OfType<Student>().Where(w => w.PersonID == personid).FirstOrDefault();

					if (student == null)
					{
						isAdd = true;
						student = new Student();
						student.rowguid = Guid.NewGuid();
						student.DateTimeStamp = DateTime.Now;

					}
					//set all properties
					student.LocationID = locid;
					student.PersonTypeID = studentTypeid;
					student.CommunityID = communityid;
					student.StatusTypeID = statustypeid;
					student.GenderID = genderid;
					student.CountyID = countyid;
					student.DJJIDNum = djjnum;
					student.FirstName = firstname.Substring(0, 1).ToUpper() + firstname.Substring(1);
					student.LastName = lastname.Substring(0, 1).ToUpper() + lastname.Substring(1);
					student.MiddleName = !string.IsNullOrEmpty(middlename) ? middlename.Substring(0, 1).ToUpper() + middlename.Substring(1) : string.Empty;
					student.Email = email;
					student.Title = title;
					student.CompanyName = company;
					student.Salutation = salutation;
					student.Honorific = honor;
					student.DateOfBirth = dob;
					student.PrimaryLanguageSpoken = primLanguage;
					student.OtherLanguagesSpoken = secLanguage;
					student.Notes = notes;
					student.LastModifiedBy = username;//always set
					student.PartOtherProgNames = otherSchoolName;
					student.MedicalConditions = medicalConditions;
					student.MedicalSpecialNeeds = speiclaNeeds;
					student.Medications = meds;
					//student.InsuranceCompany = insurance;
					//student.InsurancePolicyNum = insuranceNum;
					//student.InsurancePolicyGroupNum = insurancGroup;
					student.RideBikeHomeAlone = rideBikeAlone;
					student.RideBusAlone = rideBusAlone;
					student.SignInOut = signOut;
					student.SignedInOutGuardOnly = signOuByGuardOnly;
					student.WalkHomeAlone = walkHomeAlone;
					//student.ReleaseOther = releaseOther;
					//student.ReleaseOtherText = releaseOtherText;
					student.CaseMgrStaffPersonID = caseMrgPersonid;
					student.SchoolAttending = school;
					student.GradeLevel = gradeLevel;
					student.PartOtherProgSchool = partcipateInProg;
					student.SignatureRelease = signatureRelease;
					student.SignatureReleaseDate = releaseSignDate;
					student.SignatureProdigy = prodigyRelease;
					student.SignatureProdigyDate = prodigyReleaseDate;
					student.SignatureGrievance = grievanceSignature;
					student.SignatureGrievanceDate = grievanceSignatureDate;
					student.SignatureMedical = medicalRelease;
					student.SignatureMedicalDate = medReleaseDate;
					student.ProgramEligibilityToolCompleted = ProgramElibilityToolCompleted;
					student.YouthParentalStatus = youthParentalStatus;
					student.FamilyStatus = familyStatus;
					student.ReferredBy = referredyByList;
					student.ReferredByOther = referredByOther;
					student.Last4SSN = last4SSN;
					student.StudentID = studentId;

                    

					if (isAdd)
					{

						context.Persons.AddObject(student);
					}

					context.SaveChanges();
					personKey = student.PersonID;

				}
				catch (Exception ex)
				{
					string msg = ex.Message;
					ex.Log();
				}
				return personKey;
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
	    public static int AddUpdateStudentInfo(int personid, int? locid, int? communityid, int statustypeid, int? countyid, string djjnum, string firstname, string lastname,
	        string middlename, string email, string title, string company, string salutation, string honor, int? genderid,
	        DateTime? dob, string primLanguage, string secLanguage, string notes, string username, string school, string gradeLevel, bool? partcipateInProg, int studentTypeid, string otherSchoolName, string meds, string medicalConditions, string speiclaNeeds,
	        bool rideBusAlone, bool signOut, bool walkHomeAlone, bool rideBikeAlone, bool signOuByGuardOnly,  int? caseMrgPersonid, bool? signatureRelease, DateTime? releaseSignDate, bool? medicalRelease, DateTime? medReleaseDate,
	        bool? prodigyRelease, DateTime? prodigyReleaseDate, bool? grievanceSignature, DateTime? grievanceSignatureDate, bool ProgramElibilityToolCompleted,
	        string youthParentalStatus, string familyStatus, string referredyByList, string referredByOther, string studentId, string last4SSN, bool? isLunchReduced, bool? isFoster, bool? isMedicaid, bool? liabilityConsent, bool? grievanceConsent, bool? emergencyConsent, bool? isAssessmentok, bool? isMediaCaptureOk, bool? isAuthorizedStaffOk, bool? isDjjYouth)
	    {
	        int personKey = -1;
	        bool isAdd = false;
	        using (PODContext context = new PODContext())
	        {
	            try
	            {
	                Student student = context.Persons.OfType<Student>().Where(w => w.PersonID == personid).FirstOrDefault();

	                if (student == null)
	                {
	                    isAdd = true;
	                    student = new Student();
	                    student.rowguid = Guid.NewGuid();
	                    student.DateTimeStamp = DateTime.Now;

	                }
	                //set all properties
	                student.LocationID = locid;
	                student.PersonTypeID = studentTypeid;
	                student.CommunityID = communityid;
	                student.StatusTypeID = statustypeid;
	                student.GenderID = genderid;
	                student.CountyID = countyid;
	                student.DJJIDNum = djjnum;
	                student.FirstName = firstname.Substring(0, 1).ToUpper() + firstname.Substring(1);
	                student.LastName = lastname.Substring(0, 1).ToUpper() + lastname.Substring(1);
	                student.MiddleName = !string.IsNullOrEmpty(middlename) ? middlename.Substring(0, 1).ToUpper() + middlename.Substring(1) : string.Empty;
	                student.Email = email;
	                student.Title = title;
	                student.CompanyName = company;
	                student.Salutation = salutation;
	                student.Honorific = honor;
	                student.DateOfBirth = dob;
	                student.PrimaryLanguageSpoken = primLanguage;
	                student.OtherLanguagesSpoken = secLanguage;
	                student.Notes = notes;
	                student.LastModifiedBy = username;//always set
	                student.PartOtherProgNames = otherSchoolName;
	                student.MedicalConditions = medicalConditions;
	                student.MedicalSpecialNeeds = speiclaNeeds;
	                student.Medications = meds;
	                //student.InsuranceCompany = insurance;
	                //student.InsurancePolicyNum = insuranceNum;
	                //student.InsurancePolicyGroupNum = insurancGroup;
	                student.RideBikeHomeAlone = rideBikeAlone;
	                student.RideBusAlone = rideBusAlone;
	                student.SignInOut = signOut;
	                student.SignedInOutGuardOnly = signOuByGuardOnly;
	                student.WalkHomeAlone = walkHomeAlone;
	                //student.ReleaseOther = releaseOther;
	                //student.ReleaseOtherText = releaseOtherText;
	                student.CaseMgrStaffPersonID = caseMrgPersonid;
	                student.SchoolAttending = school;
	                student.GradeLevel = gradeLevel;
	                student.PartOtherProgSchool = partcipateInProg;
	                student.SignatureRelease = signatureRelease;
	                student.SignatureReleaseDate = releaseSignDate;
	                student.SignatureProdigy = prodigyRelease;
	                student.SignatureProdigyDate = prodigyReleaseDate;
	                student.SignatureGrievance = grievanceSignature;
	                student.SignatureGrievanceDate = grievanceSignatureDate;
	                student.SignatureMedical = medicalRelease;
	                student.SignatureMedicalDate = medReleaseDate;
	                student.ProgramEligibilityToolCompleted = ProgramElibilityToolCompleted;
	                student.YouthParentalStatus = youthParentalStatus;
	                student.FamilyStatus = familyStatus;
	                student.ReferredBy = referredyByList;
	                student.ReferredByOther = referredByOther;
	                student.Last4SSN = last4SSN;
	                student.StudentID = studentId;
	                student.IsLunchReduced = isLunchReduced;
	                student.isFosterCare = isFoster;
	                student.IsMedicaid = isMedicaid;
                    student.emergencyconsent = emergencyConsent;
                    student.liabilityconsent = liabilityConsent;
                    student.grievanceconsent = grievanceConsent;
                    student.isAssessmentOk = isAssessmentok;
                    student.isMediaCaptureOk = isMediaCaptureOk;
                    student.isAuthorizedStaffOk = isAuthorizedStaffOk;
                    student.isDJJYouth = isDjjYouth;


                    if (isAdd)
	                {

	                    context.Persons.AddObject(student);
	                }

	                context.SaveChanges();
	                personKey = student.PersonID;

	            }
	            catch (Exception ex)
	            {
	                string msg = ex.Message;
	                ex.Log();
	            }
	            return personKey;
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
        public static string AddUpdateStudentInfo(int personid, string username, string school, string gradeLevel, bool? partcipateInProg, int studentTypeid, string otherSchoolName, string meds, string medicalConditions, string speiclaNeeds,
												 bool rideBusAlone, bool signOut, bool walkHomeAlone, bool rideBikeAlone, bool signOuByGuardOnly,  int? caseMrgPersonid)
		{
			string results = string.Empty;
			bool isAdd = false;

			using (PODContext context = new PODContext())
			{
				try
				{
					Student student = context.Persons.OfType<Student>().Where(w => w.PersonID == personid).FirstOrDefault();
					if (student == null)
					{
						student = new Student();
						student.rowguid = Guid.NewGuid();
						student.DateTimeStamp = DateTime.Now;
						isAdd = true;

					}
					student.LastModifiedBy = username;
					student.PartOtherProgNames = otherSchoolName;
					student.MedicalConditions = medicalConditions;
					student.MedicalSpecialNeeds = speiclaNeeds;
					student.Medications = meds;
					//student.InsuranceCompany = insurance;
					//student.InsurancePolicyNum = insuranceNum;
					//student.InsurancePolicyGroupNum = insurancGroup;
					student.RideBikeHomeAlone = rideBikeAlone;
					student.RideBusAlone = rideBusAlone;
					student.SignInOut = signOut;
					student.SignedInOutGuardOnly = signOuByGuardOnly;
					student.WalkHomeAlone = walkHomeAlone;
					//student.ReleaseOther = releaseOther;
					//student.ReleaseOtherText = releaseOtherText;
					student.CaseMgrStaffPersonID = caseMrgPersonid;
					student.SchoolAttending = school;
					student.GradeLevel = gradeLevel;
					student.PartOtherProgSchool = partcipateInProg;
					student.StatusTypeID = studentTypeid;
					if (isAdd)
					{
						context.Persons.AddObject(student);

					}
					context.SaveChanges();
				}
				catch (Exception ex)
				{
					ex.Log();
					results = ex.Message;
				}
			}
			return results;
		}

		/// <summary>
		/// marks the person record to deleted
		/// </summary>
		/// <param name="key"></param>
		/// <returns></returns>
		public static string DeletePerson(int key)
		{
			string result = string.Empty;

			using (PODContext context = new PODContext())
			{
				try
				{
					Person deletePerson = context.Persons.FirstOrDefault(p => p.PersonID == key);
					if (deletePerson != null)
					{
						context.Persons.DeleteObject(deletePerson);
						//StatusType deleteType = context.StatusTypes.FirstOrDefault(s => s.Name.Contains("Delete"));
						//if (deleteType != null)
						//{
						//    deletePerson.StatusType = deleteType;
						//}
						context.SaveChanges();
					}

				}
				catch (Exception ex)
				{
					ex.Log();
					result = ex.Message;
				}
			}
			return result;
		}

		/// <summary>
		/// person object with all related information
		/// included in selection
		/// </summary>
		/// <param name="key">identifier</param>
		/// <returns></returns>
		public static Person GetPersonAndRelatedInfoByID(int key)
		{
			using (PODContext context = new PODContext())
			{
				return context.Persons.Include(x => x.PersonRelationships).Include(x => x.Addresses.Select(a => a.AddressType))
							.Include(x => x.Ethnicities).Include(x => x.PhoneNumbers.Select(p => p.PhoneNumberType)).Include(x => x.Races)
							.FirstOrDefault(p => p.PersonID == key);
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
			using (PODContext context = new PODContext())
			{
				return context.Persons.Include(x => x.Addresses.Select(a => a.AddressType))
					.Include(x => x.PhoneNumbers.Select(p => p.PhoneNumberType)).Include(x => x.Gender).FirstOrDefault(p => p.PersonID == key);
			}
		}


		public static Person GetStaffByUserName(string username)
		{
			StaffMember currentStaffPerson = null;
			int personId = 0;

			

			using (PODContext context = new PODContext())
			{
				try

				{
					aspnet_User currentASPNETUser = context.aspnet_Users.FirstOrDefault(p => p.UserName == username.Trim());
					if (currentASPNETUser != null)
					{
						currentStaffPerson = GetStaffByUserID(currentASPNETUser.UserId);
					}

					if (currentStaffPerson != null)
					{
						personId = GetPersonByID(currentStaffPerson.PersonID).PersonID;
					}

				}
				catch (Exception ex)
				{
					ex.Log();
					
				}

				return context.Persons.Include(x => x.Addresses.Select(a => a.AddressType))
					.Include(x => x.PhoneNumbers.Select(p => p.PhoneNumberType)).Include(x => x.Gender).FirstOrDefault(p => p.PersonID == personId);
			}
		}
		/// <summary>
		/// this only gets staff member  object 
		/// /// </summary>
		/// <param name="key">identifier</param>
		/// <returns></returns>
		public static StaffMember GetStaffByUserID(Guid key)
		{
			using (PODContext context = new PODContext())
			{
				return context.Persons.OfType<StaffMember>().Include(x => x.Addresses.Select(a => a.AddressType)).Include(x => x.Gender).FirstOrDefault(p => p.UserID == key);
			}
		}

		/// <summary>
		/// this gets person audit record if exist
		/// is included
		/// </summary>
		/// <param name="key">identifier</param>
		/// <returns></returns>
		public static Persons_Audit GetPersonAudit(int key)
		{
			using (PODContext context = new PODContext())
			{
				return context.Persons_Audit.Where(p => p.PersonID == key).OrderByDescending(p => p.DateTimeStamp).FirstOrDefault();
			}
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
				return context.Persons.Include(x => x.Addresses.Select(a => a.AddressType)).Include(x => x.Gender)
							  .Include(x => x.PhoneNumbers.Select(p => p.PhoneNumberType))
							  .Where(p => p.Enrollments.Count > 0 && p.PersonType.Name == "Student" &&
										  p.FirstName.Trim().ToLower() == firstname.ToLower() &&
										  p.LastName.Trim().ToLower() == lastname.ToLower()
				&& (!dob.HasValue || !p.DateOfBirth.HasValue || (dob.HasValue && p.DateOfBirth.HasValue && p.DateOfBirth.Value.Day == dob.Value.Day && p.DateOfBirth.Value.Month == dob.Value.Month && p.DateOfBirth.Value.Year == dob.Value.Year))).ToList();
			}
		}

		/// <summary>
		/// returns list of non staff with no djjnum assigned yet
		/// </summary>
		/// <returns></returns>
		public static List<Person> GetPRefilteredDJJNumPossibleMatches()
		{
			using (PODContext context = new PODContext())
			{
				return context.Persons.Include(x => x.Gender).Where(p => p.PersonType.Name == "Student" && (p.DJJIDNum == null || p.DJJIDNum == "")).ToList();
			}
		}

		/// <summary>
		/// update youths djj number
		/// and sets latest pre enrolled enrollment to 
		/// enrolled
		/// </summary>
		/// <param name="youthList"></param>
		/// <returns></returns>
		public static string UpdateYouthsDJJNumberandEnrollmentStatus(List<ImportPerson> youthList)
		{
			string result = string.Empty;
			try
			{
				using (PODContext context = new PODContext())
				{
					foreach (ImportPerson ip in youthList)
					{
						//get person
						Person currentYouth = context.Persons.FirstOrDefault(p => p.PersonID == ip.PersonID);
						if (currentYouth != null)//set djj number
						{
							currentYouth.DJJIDNum = ip.DJJNumber;
						}
						//get enrollment status and current enrollment
						int? enrolledStatus = null;
						StatusType type = context.StatusTypes.FirstOrDefault(s => s.Name.ToLower() == "enrolled");
						if (type != null)
						{
							enrolledStatus = type.StatusTypeID;
						}
						Enrollment currentEnrollment = context.Enrollments.Where(en => en.PersonID == ip.PersonID && en.StatusType.Name.ToLower() == "rollover").OrderByDescending(en => en.DateApplied).FirstOrDefault();
						if (currentEnrollment != null)//update status to be enrolled
						{
							if (currentEnrollment.DateApplied.HasValue && enrolledStatus.HasValue)
							{
								currentEnrollment.StatusTypeID = enrolledStatus.Value;
							}
						}
					}
					context.SaveChanges();
				}
			}
			catch (Exception ex)
			{
				ex.Log();
				result = ex.Message;
			}

			return result;

		}

		/// <summary>
		/// this gets possible people matches counts
		/// based on name and dob
		/// </summary>
		/// <param name="key">indetifier</param>
		/// <returns></returns>
		public static int GetPeopleByNameMatchCount(string firstname, string lastname,  DateTime? dob)
		{
			using (PODContext context = new PODContext())
			{
				return
					context.Persons.Count(
						p => p.Enrollments.Count > 0 &&
						p.PersonType.Name == "Student" &&
						p.FirstName.Trim().ToLower() == firstname.ToLower() && p.LastName.Trim().ToLower() == lastname.ToLower()
																						  && (!dob.HasValue || !p.DateOfBirth.HasValue || (dob.HasValue && p.DateOfBirth.HasValue && p.DateOfBirth.Value.Day == dob.Value.Day && p.DateOfBirth.Value.Month == dob.Value.Month && p.DateOfBirth.Value.Year == dob.Value.Year)));
			}
		}

		/// <summary>
		/// this gets possible people matches
		/// based on name 
		/// </summary>
		/// <param name="key">indetifier</param>
		/// <returns></returns>
		public static List<Person> GetPeopleByNameMatch(string firstname, string lastname)
		{
			using (PODContext context = new PODContext())
			{
				return context.Persons.Include(x => x.Addresses.Select(a => a.AddressType)).Include(x => x.PhoneNumbers.Select(p => p.PhoneNumberType)).Where(p => p.Enrollments.Count > 1
					&& p.PersonType.Name == "Student" && p.FirstName.Trim().ToLower() == firstname.ToLower() && p.LastName.Trim().ToLower() == lastname.ToLower()).ToList();
			}
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
		public static List<sp_GetPersonEnrollments_Result> GetPersonBySearch(int programid, int? siteID, int? grantyearID, string name, string guardian, string zip, string school, int? type, int? status, DateTime? startDate, DateTime? endDate, string races, string djjNum)
		{
			List<sp_GetPersonEnrollments_Result> studentList = NewMethod();
			using (PODContext context = new PODContext())
			{
				string xmlRaces = null;
				if (!string.IsNullOrEmpty(races))
				{
					int value;
					int[] raceIds = races.Split('+', ' ')
										 .Select(x => int.TryParse(x, out value) ? value : (int?)null)
										 .Where(x => x != null)
										 .Select(x => x.Value)
										 .ToArray();
					if (raceIds.Length > 0)
					{
						var serializer = new XmlSerializer(typeof(int[]));
						using (var stream = new MemoryStream())
						{
							serializer.Serialize(stream, raceIds);
							xmlRaces = Encoding.UTF8.GetString(stream.ToArray());
						}
					}
				}
				
				
				studentList = context.sp_GetPersonEnrollments(name, guardian, type, status, school, startDate, endDate, zip, programid, siteID, grantyearID, djjNum, xmlRaces).ToList();
			}
			return studentList;
		}

		public static List<sp_GetPersonEnrollments2_Result> GetPersonBySearch(int programid, int? siteID, int? grantyearID, string name, string guardian, string zip, string school, int? type, int? status, DateTime? startDate, DateTime? endDate, string races, string djjNum, string isdjjyouth)
		{
			List<sp_GetPersonEnrollments2_Result> studentList = NewMethod2();
			using (PODContext context = new PODContext())
			{
				string xmlRaces = null;
				if (!string.IsNullOrEmpty(races))
				{
					int value;
					int[] raceIds = races.Split('+', ' ')
										 .Select(x => int.TryParse(x, out value) ? value : (int?)null)
										 .Where(x => x != null)
										 .Select(x => x.Value)
										 .ToArray();
					if (raceIds.Length > 0)
					{
						var serializer = new XmlSerializer(typeof(int[]));
						using (var stream = new MemoryStream())
						{
							serializer.Serialize(stream, raceIds);
							xmlRaces = Encoding.UTF8.GetString(stream.ToArray());
						}
					}
				}


				studentList = context.sp_GetPersonEnrollments2(name, guardian, type, status, school, startDate, endDate, zip, programid, siteID, grantyearID, djjNum, xmlRaces, isdjjyouth).ToList();
			}
			return studentList;
		}

		private static List<sp_GetPersonEnrollments_Result> NewMethod()
		{
			return new List<sp_GetPersonEnrollments_Result>();
		}

		private static List<sp_GetPersonEnrollments2_Result> NewMethod2()
		{
			return new List<sp_GetPersonEnrollments2_Result>();
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
			List<BulkEditStudents_Result> studentList = new List<BulkEditStudents_Result>();
			using (PODContext context = new PODContext())
			{
				studentList = context.GetPersonForBulkEdit(programid, siteid, enrollmentTypeID, noAttendance, rollOver).ToList();
			}
			
			return studentList.ToList();
		}

		public static List<sp_ReleasedYouthByDate_Result> GetReleasedYouthByDate( DateTime? releaseDate, int? siteid)
		{
			List<sp_ReleasedYouthByDate_Result> youthlist = new List<sp_ReleasedYouthByDate_Result>();
			using (PODContext context = new PODContext())
			{
				youthlist = context.sp_ReleasedYouthByDate(siteid, releaseDate).ToList();
			}

			
			return youthlist.ToList();
		}

		public static List<sp_GetPersonForBulkRelease_Result> GetYouthBulkRelease(int programid, int? siteid, int? enrollmentTypeID, bool? noAttendance, bool? rollOver, int? GrantYearid, int? YouthTypeid)
		{
			List<sp_GetPersonForBulkRelease_Result> studentList = new List<sp_GetPersonForBulkRelease_Result>();
			using (PODContext context = new PODContext())
			{
				studentList = context.sp_GetPersonForBulkRelease(programid, siteid, enrollmentTypeID, noAttendance, rollOver, GrantYearid, YouthTypeid).ToList();
			}

			return studentList.ToList();
		}


		public static IEnumerable<Person> GetAllPeople(string searchtext)
		{
			using (PODContext context = new PODContext())
			{
				return context.Persons.Where(p => (p.FirstName.ToLower().Contains(searchtext) || p.LastName.ToLower().Contains(searchtext)) && p.StatusType.Name == "Active").OrderBy(p => p.FirstName).ThenBy(p => p.LastName).ToList();
			}

		}

		/// <summary>
		/// gets all related people by type
		/// is included
		/// </summary>
		/// <param name="key">identifier</param>
		/// <param name="relationTypekey">relationship type identifer</param>
		/// <returns></returns>
		public static IList<Person> GetPersonsByRelationTypeAndID(int personID, int relationTypekey)
		{
			List<Person> relatedpeople = new List<Person>();
			List<Person> fullRelationPeople = new List<Person>();
			using (PODContext context = new PODContext())
			{
				Person currentPerson = context.Persons.FirstOrDefault(p => p.PersonID == personID);
				if (currentPerson != null)
				{
					relatedpeople = currentPerson.PersonRelationships.Where(r => r.PersonID == currentPerson.PersonID && r.PersonRelationshipType.PersonRelationshipTypeID == relationTypekey).Select(r => r.RelatedPerson).ToList();
				}
				foreach (Person relperson in relatedpeople)
				{
					Person fullItemPerson = context.Persons.Include(x => x.Addresses.Select(a => a.AddressType)).Include(x => x.PhoneNumbers.Select(p => p.PhoneNumberType)).FirstOrDefault(p => p.PersonID == relperson.PersonID);
					fullItemPerson.RelationshipTypeName = currentPerson.PersonRelationships.Where(r => r.RelatedPersonID == relperson.PersonID).Select(r => r.PersonRelationshipType.Name).FirstOrDefault();
					fullRelationPeople.Add(fullItemPerson);
				}
				return fullRelationPeople;
			}
		}

		/// <summary>
		/// gets all related people for person
		/// is included
		/// </summary>
		/// <param name="key">identifier</param>
		/// <returns></returns>
		public static IList<Person> GetRelatedPersonsByID(int personID)
		{
			List<Person> relatedpeople = new List<Person>();
			List<Person> fullRelationPeople = new List<Person>();
			using (PODContext context = new PODContext())
			{
				Person currentPerson = context.Persons.FirstOrDefault(p => p.PersonID == personID);
				//
				if (currentPerson != null)
				{
					relatedpeople = currentPerson.PersonRelationships.Where(r => r.PersonID == currentPerson.PersonID).Select(r => r.RelatedPerson).ToList();
				}
				foreach (Person relperson in relatedpeople)
				{
					Person fullItemPerson = context.Persons.Include(x => x.Addresses.Select(a => a.AddressType)).Include(x => x.PhoneNumbers.Select(p => p.PhoneNumberType)).Include(x => x.PersonType).FirstOrDefault(p => p.PersonID == relperson.PersonID);
					fullItemPerson.RelationshipTypeName = currentPerson.PersonRelationships.Where(r => r.RelatedPersonID == relperson.PersonID).Select(r => r.PersonRelationshipType.Name).FirstOrDefault();
					fullRelationPeople.Add(fullItemPerson);
				}

				return fullRelationPeople;
			}
		}

		/// <summary>
		/// gets all guardians for a person
		/// </summary>
		/// <param name="key">identifier</param>
		/// <returns></returns>
		public static IList<Person> GetGuardiansByID(int personID)
		{
			IList<Person> relatedpeople = new List<Person>();
			IList<Person> fullRelationPeople = new List<Person>();
			using (PODContext context = new PODContext())
			{
				Person currentPerson = context.Persons.FirstOrDefault(p => p.PersonID == personID);
				if (currentPerson != null)
				{
					relatedpeople = currentPerson.PersonRelationships.Where(w => w.IsGuardian == true).Select(s => s.RelatedPerson).ToList();
				}
				foreach (Person relperson in relatedpeople)
				{
					Person fullItemPerson = context.Persons.Include(x => x.Addresses.Select(a => a.AddressType)).Include(x => x.PhoneNumbers.Select(p => p.PhoneNumberType)).FirstOrDefault(p => p.PersonID == relperson.PersonID);
					fullItemPerson.RelationshipTypeName = currentPerson.PersonRelationships.Where(r => r.RelatedPersonID == relperson.PersonID).Select(r => r.PersonRelationshipType.Name).FirstOrDefault();
					fullItemPerson.IsER = currentPerson.PersonRelationships.Any(w => w.RelatedPersonID == relperson.PersonID && w.IsEmergencyContact == true) ? "True" : "False";
                    fullItemPerson.RelationshipOther = currentPerson.PersonRelationships.Where(r => r.RelatedPersonID == relperson.PersonID).Select(r => r.RelationShipOther).FirstOrDefault();
                    fullRelationPeople.Add(fullItemPerson);
				}
				return fullRelationPeople;
			}
		}

		/// <summary>
		/// gets all er contacts for a person
		/// </summary>
		/// <param name="key">identifier</param>
		/// <returns></returns>
		public static IList<Person> GetEmergencyContactsByID(int personID)
		{
			IList<Person> relatedpeople = new List<Person>();
			IList<Person> fullRelationPeople = new List<Person>();
			using (PODContext context = new PODContext())
			{
				Person currentPerson = context.Persons.FirstOrDefault(p => p.PersonID == personID);
				if (currentPerson != null)
				{
					relatedpeople = currentPerson.PersonRelationships.Where(w => w.IsEmergencyContact == true).Select(s => s.RelatedPerson).ToList();
				}
				foreach (Person relperson in relatedpeople)
				{
					Person fullItemPerson = context.Persons.Include(x => x.Addresses.Select(a => a.AddressType)).Include(x => x.PhoneNumbers.Select(p => p.PhoneNumberType)).FirstOrDefault(p => p.PersonID == relperson.PersonID);
					fullItemPerson.RelationshipTypeName = currentPerson.PersonRelationships.Where(r => r.RelatedPersonID == relperson.PersonID).Select(r => r.PersonRelationshipType.Name).FirstOrDefault();
				    fullItemPerson.IsER = currentPerson.PersonRelationships.Any(w => w.RelatedPersonID == relperson.PersonID && w.IsEmergencyContact == true) ? "True" : "False";
				    fullItemPerson.RelationshipOther = currentPerson.PersonRelationships.Where(r => r.RelatedPersonID == relperson.PersonID).Select(r => r.RelationShipOther).FirstOrDefault();
                    
                    fullRelationPeople.Add(fullItemPerson);
				}
				return fullRelationPeople;
			}
		}

		public static string DeleteEmergencyContacts(int personID, int erPersonID)
		{
			string result = string.Empty;
			using (PODContext context = new PODContext())
			{
				try
				{
					PersonRelationship relShip = context.PersonRelationships.FirstOrDefault(p => p.PersonID == personID && p.RelatedPersonID == erPersonID && p.IsEmergencyContact == true);
					if (relShip != null)
					{
						context.PersonRelationships.DeleteObject(relShip);
						context.SaveChanges();
					}
				}
				catch (Exception ex)
				{
					ex.Log();
					result = ex.Message;
				}
				return result;
			}
		}
		public static string DeleteEnrollmentNote(int enrollmentNoteId)
		{
			string result = string.Empty;
			using (PODContext context = new PODContext())
			{
				try
				{
					EnrollmentNote enrollNote = context.EnrollmentNotes.FirstOrDefault(p => p.EnrollmentNoteID == enrollmentNoteId);
					if (enrollNote != null)
					{
						context.EnrollmentNotes.DeleteObject(enrollNote);
						context.SaveChanges();
					}
				}
				catch (Exception ex)
				{

					throw;
				}
				return result;
			}
		}

		public static string DeleteAutorizedContacts(int personID, int erPersonID)
		{
			string result = string.Empty;
			using (PODContext context = new PODContext())
			{
				try
				{
					PersonRelationship relShip = context.PersonRelationships.FirstOrDefault(p => p.PersonID == personID && p.RelatedPersonID == erPersonID && p.IsAuthPerson == true);
					if (relShip != null)
					{
						context.PersonRelationships.DeleteObject(relShip);
						context.SaveChanges();
					}
				}
				catch (Exception ex)
				{
					ex.Log();
					result = ex.Message;
				}
				return result;
			}
		}

		public static string DeletePhysicianContacts(int personID, int erPersonID)
		{
			string result = string.Empty;
			using (PODContext context = new PODContext())
			{
				try
				{
					PersonRelationship relShip = context.PersonRelationships.FirstOrDefault(p => p.PersonID == personID && p.RelatedPersonID == erPersonID && p.IsPhysician == true);
					if (relShip != null)
					{
						context.PersonRelationships.DeleteObject(relShip);
						context.SaveChanges();
					}
				}
				catch (Exception ex)
				{
					ex.Log();
					result = ex.Message;
				}
				return result;
			}
		}

		/// <summary>
		/// gets all er contacts for a person
		/// </summary>
		/// <param name="key">identifier</param>
		/// <returns></returns>
		public static IEnumerable<Person> GetAuthorizedToPickupPeopleByID(int personID)
		{
			IList<Person> relatedpeople = new List<Person>();
			IList<Person> fullRelationPeople = new List<Person>();
			using (PODContext context = new PODContext())
			{
				Person currentPerson = context.Persons.FirstOrDefault(p => p.PersonID == personID);
				if (currentPerson != null)
				{
					relatedpeople = currentPerson.PersonRelationships.Where(w => 
                    w.IsAuthPerson == true || 
                    w.IsEmergencyContact == true).Select(s => s.RelatedPerson).ToList();
				}
				foreach (Person relperson in relatedpeople)
				{
					Person fullItemPerson = context.Persons.Include(x => x.Addresses.Select(a => a.AddressType)).Include(x => x.PhoneNumbers.Select(p => p.PhoneNumberType)).FirstOrDefault(p => p.PersonID == relperson.PersonID);
					fullItemPerson.IsER = currentPerson.PersonRelationships.Any(w => w.RelatedPersonID == relperson.PersonID && w.IsEmergencyContact == true) ? "Yes" : "No";
					fullItemPerson.RelationshipTypeName = currentPerson.PersonRelationships.Where(r => r.RelatedPersonID == relperson.PersonID).Select(r => r.PersonRelationshipType.Name).FirstOrDefault();
					fullRelationPeople.Add(fullItemPerson);
				}
				return fullRelationPeople;
			}
		}

		public static IList<Person> GetAuthorizedToPickupPeopleByID_New(int personID)
		{
			IList<Person> relatedpeople = new List<Person>();
			IList<Person> fullRelationPeople = new List<Person>();
			using (PODContext context = new PODContext())
			{
				Person currentPerson = context.Persons.FirstOrDefault(p => p.PersonID == personID);
				if (currentPerson != null)
				{
					relatedpeople = currentPerson.PersonRelationships.Where(w =>
					w.IsAuthPerson == true ||
					w.IsEmergencyContact == true).Select(s => s.RelatedPerson).ToList();
				}
				foreach (Person relperson in relatedpeople)
				{
					Person fullItemPerson = context.Persons.Include(x => x.Addresses.Select(a => a.AddressType)).Include(x => x.PhoneNumbers.Select(p => p.PhoneNumberType)).FirstOrDefault(p => p.PersonID == relperson.PersonID);
					fullItemPerson.IsER = currentPerson.PersonRelationships.Any(w => w.RelatedPersonID == relperson.PersonID && w.IsEmergencyContact == true) ? "Yes" : "No";
					fullItemPerson.RelationshipTypeName = currentPerson.PersonRelationships.Where(r => r.RelatedPersonID == relperson.PersonID).Select(r => r.PersonRelationshipType.Name).FirstOrDefault();
					fullRelationPeople.Add(fullItemPerson);
				}
				return fullRelationPeople;
			}
		}


		public static IEnumerable<Person> GetAuthorizedWithoutGuardiansToPickupPeopleByID(int personID)
        {
            IList<Person> relatedpeople = new List<Person>();
            IList<Person> fullRelationPeople = new List<Person>();
            using (PODContext context = new PODContext())
            {
                Person currentPerson = context.Persons.FirstOrDefault(p => p.PersonID == personID);
                if (currentPerson != null)
                {
                    relatedpeople = currentPerson.PersonRelationships.Where(w =>
                    w.IsAuthPerson == true ||
                    w.IsEmergencyContact == true &&
                    w.IsGuardian != true).Select(s => s.RelatedPerson).ToList();
                }
                foreach (Person relperson in relatedpeople)
                {
                    Person fullItemPerson = context.Persons.Include(x => x.Addresses.Select(a => a.AddressType)).Include(x => x.PhoneNumbers.Select(p => p.PhoneNumberType)).FirstOrDefault(p => p.PersonID == relperson.PersonID);
                    fullItemPerson.IsER = currentPerson.PersonRelationships.Any(w => w.RelatedPersonID == relperson.PersonID && w.IsEmergencyContact == true) ? "Yes" : "No";
                    fullItemPerson.RelationshipTypeName = currentPerson.PersonRelationships.Where(r => r.RelatedPersonID == relperson.PersonID).Select(r => r.PersonRelationshipType.Name).FirstOrDefault();
                    fullRelationPeople.Add(fullItemPerson);
                }
                return fullRelationPeople;
            }
        }

        /// <summary>
        /// gets all physicians for a person
        /// </summary>
        /// <param name="key">identifier</param>
        /// <returns></returns>
        public static IList<Person> GetDoctorsByID(int personID)
		{
			IList<Person> relatedpeople = new List<Person>();
			IList<Person> fullRelationPeople = new List<Person>();
			using (PODContext context = new PODContext())
			{
				Person currentPerson = context.Persons.FirstOrDefault(p => p.PersonID == personID);
				if (currentPerson != null)
				{
					relatedpeople = currentPerson.PersonRelationships.Where(w => w.IsPhysician).Select(s => s.RelatedPerson).ToList();
				}
				foreach (Person relperson in relatedpeople)
				{
					Person fullItemPerson = context.Persons.Include(x => x.Addresses.Select(a => a.AddressType)).Include(x => x.PhoneNumbers.Select(p => p.PhoneNumberType)).FirstOrDefault(p => p.PersonID == relperson.PersonID);
					fullItemPerson.RelationshipTypeName = currentPerson.PersonRelationships.Where(r => r.RelatedPersonID == relperson.PersonID).Select(r => r.PersonRelationshipType.Name).FirstOrDefault();
					fullRelationPeople.Add(fullItemPerson);
				}

				return fullRelationPeople;
			}
		}

		/// <summary>
		/// gets allstaff members for location or all
		/// </summary>
		/// <param name="key">location identifier</param>
		/// <returns>list</returns>
		public static IList<StaffMember> GetStaff(int? siteID)
		{
			IList<StaffMember> staff = new List<StaffMember>();

			using (PODContext context = new PODContext())
			{
				if (siteID.HasValue)
				{
					staff = context.Persons.OfType<StaffMember>().Where(s => (s.LocationID.HasValue && (s.LocationID == siteID || s.Location.SiteLocationID.HasValue && s.Location.SiteLocationID == siteID)) && s.StatusType.Name.ToLower() == "active").Distinct().ToList();
				}
				else
				{
					staff = context.Persons.OfType<StaffMember>().Where(s => s.StatusType.Name.ToLower() == "active").Distinct().ToList();
				}
				return staff;
			}
		}

		/// <summary>
		/// gets all students that are active
		/// </summary>
		/// <returns>list</returns>
		public static IList<Student> GetStudents()
		{
			IList<Student> students = new List<Student>();

			using (PODContext context = new PODContext())
			{
				students = context.Persons.OfType<Student>().Where(s => s.StatusType.Name.ToLower() == "active").OrderBy(s => s.LastName).ThenBy(s => s.FirstName).ToList();

				return students;
			}
		}

		public static IList<Student> GetStudents(int siteid)
		{
			IList<Student> students = new List<Student>();

			using (PODContext context = new PODContext())
			{
				students = context.Persons.OfType<Student>().Where(s => (s.LocationID == siteid || (s.Location.SiteLocationID.HasValue && s.Location.SiteLocationID.Value == siteid)) && s.StatusType.Name.ToLower() == "active").OrderBy(s => s.LastName).ThenBy(s => s.FirstName).ToList();

				return students;
			}
		}

		/// <summary>
		/// gets all students that are assigned to course
		/// </summary>
		/// <returns>list</returns>
		public static IEnumerable<Student> GetStudentsByCourseInstanceID(int id)
		{
			IList<Student> students = new List<Student>();

			using (PODContext context = new PODContext())
			{
				students = context.Persons.OfType<Student>().Include(x => x.Gender).Where(s => s.CourseInstances.Any(c => c.CourseInstanceID == id)).OrderBy(c => c.LastName).ThenBy(c => c.FirstName).ToList();

				return students;
			}
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
			string results = string.Empty;
			using (PODContext context = new PODContext())
			{
				try
				{
					Person currentPerson = context.Persons.FirstOrDefault(p => p.PersonID == key);
					if (currentPerson != null)
					{
                        if(currentPerson.Ethnicities != null)
                        {
                            currentPerson.Ethnicities.Clear();
                            context.SaveChanges();
                            currentPerson = context.Persons.FirstOrDefault(p => p.PersonID == key);
                        }

						var ethnicities = context.Ethnicities.Where(e => ethnicityKeyList.Contains(e.EthnicityID));
						foreach (Ethnicity eth in ethnicities)
						{


							//check if added already then add
							if (!currentPerson.Ethnicities.Any(e => e.EthnicityID == eth.EthnicityID))
							{
								currentPerson.Ethnicities.Add(eth);
							}
						}
						context.SaveChanges();
					}
				}
				catch (Exception ex)
				{
					ex.Log();
					results = ex.Message;
				}
			}

			return results;
		}

		/// <summary>
		/// adds existing addresses to person record
		/// </summary>
		/// <param name="key">Person Identifier</param>
		/// <param name="addresskeyList">list of addresses</param>
		/// <returns></returns>
		public static string AddAddressToPerson(int key, List<int> addresskeyList)
		{
			string results = string.Empty;
			using (PODContext context = new PODContext())
			{
				try
				{
					Person currentPerson = context.Persons.FirstOrDefault(p => p.PersonID == key);
					if (currentPerson != null)
					{
						var addressess = context.Addresses.Where(a => addresskeyList.Contains(a.AddressID)).ToList();
						foreach (Address adr in addressess)
						{
							//check if added already then add
							if (!currentPerson.Addresses.Any(a => a.AddressID == adr.AddressID))
							{
								currentPerson.Addresses.Add(adr);
							}
						}
						context.SaveChanges();
					}
				}
				catch (Exception ex)
				{
					ex.Log();
					results = ex.Message;
				}
			}

			return results;
		}

		/// <summary>
		/// adds existing addresses to person record
		/// </summary>
		/// <param name="key">Person Identifier</param>
		/// <param name="addresskeyList">list of addresses</param>
		/// <returns></returns>
		public static string AddSchoolAddressToStudent(int key, int addresskey)
		{
			string results = string.Empty;
			using (PODContext context = new PODContext())
			{
				try
				{
					Student currentPerson = context.Persons.OfType<Student>().FirstOrDefault(p => p.PersonID == key);
					if (currentPerson != null)
					{
						var address = context.Addresses.FirstOrDefault(a => a.AddressID == addresskey);
						if (address != null)
						{
							currentPerson.SchoolAddressID = addresskey;
						}
						context.SaveChanges();
					}
				}
				catch (Exception ex)
				{
					ex.Log();
					results = ex.Message;
				}
			}

			return results;
		}

		public static string DeleteAddressFromPerson(int key, int addressid)
		{
			string results = string.Empty;
			using (PODContext context = new PODContext())
			{
				try
				{
					Person currentPerson = context.Persons.FirstOrDefault(p => p.PersonID == key);
					if (currentPerson != null)
					{
						var adr = context.Addresses.FirstOrDefault(a => a.AddressID == addressid);
						if (adr != null)
						{
							currentPerson.Addresses.Remove(adr);
						}
						context.SaveChanges();
					}
				}
				catch (Exception ex)
				{
					ex.Log();
					results = ex.Message;
				}
			}

			return results;
		}

		/// <summary>
		/// adds existing phone numbers to person record
		/// </summary>
		/// <param name="key">Person Identifier</param>
		/// <param name="addresskeyList">list of phone numbers</param>
		/// <returns></returns>
		public static string AddPhoneNumbersToPerson(int key, List<int> numberskeyList)
		{
			string results = string.Empty;
			using (PODContext context = new PODContext())
			{
				try
				{
					Person currentPerson = context.Persons.FirstOrDefault(p => p.PersonID == key);
					if (currentPerson != null)
					{
						var numbers = context.PhoneNumbers.Where(p => numberskeyList.Contains(p.PhoneNumberID));
						foreach (PhoneNumber ph in numbers)
						{
							//check if added already then add
							if (!currentPerson.PhoneNumbers.Any(p => p.PhoneNumberID == ph.PhoneNumberID))
							{
								currentPerson.PhoneNumbers.Add(ph);
							}
						}
						context.SaveChanges();
					}
				}
				catch (Exception ex)
				{
					ex.Log();
					results = ex.Message;
				}
			}

			return results;
		}

		public static string DeletePhoneNumberFromPerson(int key, int phoneid)
		{
			string results = string.Empty;
			using (PODContext context = new PODContext())
			{
				try
				{
					Person currentPerson = context.Persons.FirstOrDefault(p => p.PersonID == key);
					if (currentPerson != null)
					{
						var number = context.PhoneNumbers.FirstOrDefault(p => p.PhoneNumberID == phoneid);
						if (number != null)
						{
							currentPerson.PhoneNumbers.Remove(number);
						}
						context.SaveChanges();
					}
				}
				catch (Exception ex)
				{
					ex.Log();
					results = ex.Message;
				}
			}

			return results;
		}
		/// <summary>
		/// adds existing Races to person record
		/// </summary>
		/// <param name="key">Person ID</param>
		/// <param name="ethnicityKeyList">Races Identifiers</param>
		/// <returns></returns>
		public static string AddRacesToPerson(int key, List<int> racesKeyList)
		{
			string results = string.Empty;
			using (PODContext context = new PODContext())
			{
				try
				{
					Person currentPerson = context.Persons.FirstOrDefault(p => p.PersonID == key);
					if (currentPerson != null)
					{
						var currentRaces = currentPerson.Races.ToList();
						foreach (Race r in currentRaces)
						{
							currentPerson.Races.Remove(r);

						}
						context.SaveChanges();

						var races = context.Races.Where(r => racesKeyList.Contains(r.RaceID));
						foreach (Race race in races)
						{
							currentPerson.Races.Add(race);
						}
						context.SaveChanges();
					}
				}
				catch (Exception ex)
				{
					ex.Log();
					results = ex.Message;
				}
			}

			return results;
		}

		/// <summary>
		/// adds locations to person record
		/// </summary>
		/// <param name="key">Person ID</param>
		/// <param name="locationId">Location ID</param>
		/// <returns></returns>
		public static string SetLocationForPerson(int key, int locationId)
		{
			string results = string.Empty;
			using (PODContext context = new PODContext())
			{
				try
				{
					Person currentPerson = context.Persons.FirstOrDefault(p => p.PersonID == key);
					if (currentPerson != null)
					{
						var location = context.Locations.SingleOrDefault(l => l.LocationID == locationId);

						if (location != null
							&& currentPerson.LocationID != location.LocationID)
						{
							currentPerson.Location = location;
						}

						context.SaveChanges();
					}
				}
				catch (Exception ex)
				{
					ex.Log();
					results = ex.Message;
				}
			}

			return results;
		}

		/// <summary>
		/// adds existing Course Instances to person record
		/// </summary>
		/// <param name="key">Person ID</param>
		/// <param name="ethnicityKeyList">course Identifiers</param>
		/// <returns></returns>
		public static string AddCourseInstancesToPerson(int key, List<int> coursesInstanceKeyList)
		{
			string results = string.Empty;
			using (PODContext context = new PODContext())
			{
				try
				{
					Person currentPerson = context.Persons.FirstOrDefault(p => p.PersonID == key);
					if (currentPerson != null)
					{
						var courses = context.CourseInstances.Where(r => coursesInstanceKeyList.Contains(r.CourseInstanceID));
						foreach (CourseInstance cInst in courses)
						{
							//check if added already then add
							if (!currentPerson.CourseInstances.Any(e => e.CourseInstanceID == cInst.CourseInstanceID))
							{
								currentPerson.CourseInstances.Add(cInst);
							}
						}
						context.SaveChanges();
					}
				}
				catch (Exception ex)
				{
					ex.Log();
					results = ex.Message;
				}
			}

			return results;
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
			string results = string.Empty;
			using (PODContext context = new PODContext())
			{
				try
				{
					Person currentPerson = context.Persons.FirstOrDefault(p => p.PersonID == personid);
					if (currentPerson != null)
					{
						PersonRelationship relationship = currentPerson.PersonRelationships.FirstOrDefault(r => r.RelatedPersonID == relatedpersonid);
						if (relationship == null)
						{
							relationship = new PersonRelationship();
							relationship.rowguid = Guid.NewGuid();
							relationship.DateTimeStamp = DateTime.Now;
							relationship.RelatedPersonID = relatedpersonid;
							relationship.IsActive = true;
							relationship.PersonRelationshipTypeID = relationshiptypeid;
							relationship.IsAuthPerson = isAuthorized;
							relationship.IsGuardian = isGuardian;
							relationship.IsEmergencyContact = isER;
							relationship.IsPhysician = isPhysician;
							relationship.PersonID = personid;
							relationship.RelationShipOther = relationshipOther;
							context.PersonRelationships.AddObject(relationship);
							context.SaveChanges();
						}
						else
						{
							relationship.IsActive = true;
							relationship.IsAuthPerson = isAuthorized;
							relationship.IsGuardian = isGuardian;
							relationship.PersonRelationshipTypeID = relationshiptypeid;
							relationship.IsPhysician = isPhysician;
							relationship.RelationShipOther = relationshipOther;
							relationship.IsEmergencyContact = isER;
							context.SaveChanges();
						}
					}
				}
				catch (Exception ex)
				{
					ex.Log();
					results = ex.Message;
				}
			}
			return results;
		}

		public static string  DeletePersonRelationship(int key)
		{
			string result = string.Empty;

			using (PODContext context = new PODContext())
			{
				try
				{
					PersonRelationship deletePersonRelationship = context.PersonRelationships.FirstOrDefault(p => p.RelatedPersonID == key);
					if (deletePersonRelationship != null)
					{
						context.PersonRelationships.DeleteObject(deletePersonRelationship);
						//StatusType deleteType = context.StatusTypes.FirstOrDefault(s => s.Name.Contains("Delete"));
						//if (deleteType != null)
						//{
						//    deletePerson.StatusType = deleteType;
						//}
						context.SaveChanges();
					}

				}
				catch (Exception ex)
				{
					ex.Log();
					result = ex.Message;
				}
			}
			return result;
		}

		public static string UpdatePersonLocation(int personid, int locationid, string username)
		{
			string result = string.Empty;
			using (PODContext context = new PODContext())
			{
				try
				{
					Person currentPerson = context.Persons.FirstOrDefault(p => p.PersonID == personid);
					if (currentPerson != null)
					{
						currentPerson.LocationID = locationid;
						currentPerson.LastModifiedBy = username;
					}
					context.SaveChanges();
				}
				catch (Exception ex)
				{
					ex.Log();
					result = ex.Message;
				}
			}
			return result;
		}

		/// <summary>
		///counts attendance hours and determines eligibility for certificate
		/// </summary>
		/// <returns>list</returns>
		public static bool GetStudentEligibleForCertificate(int personid, int enrollmentid, int riskID)
		{
			bool isEligible = false;
			DateTime? startGrantYear = null;
			DateTime? endGrantYear = null;

			using (PODContext context = new PODContext())
			{
				var student = context.Persons.OfType<Student>().Include(x => x.ClassAttendances).Include(x => x.Enrollments).FirstOrDefault(s => s.PersonID == personid);
				if (student != null)
				{
					if (student.Enrollments != null)
					{
						Enrollment currentEnrollment = null;
						if (enrollmentid != 0)
						{
							currentEnrollment = student.Enrollments.FirstOrDefault(c => c.EnrollmentID == enrollmentid);
						}
						else
						{
							currentEnrollment = student.Enrollments.FirstOrDefault(c => c.RiskAssessmentID.HasValue && c.RiskAssessmentID.Value == riskID);
						}
						if (currentEnrollment != null && currentEnrollment.EnrollmentType.Name == "Diversion Youth")
						{
							if (currentEnrollment.DateAdmitted.HasValue)
							{
								TimePeriod currentPeriod = context.TimePeriods.FirstOrDefault(tp => tp.StartDate.HasValue && tp.EndDate.HasValue &&
														currentEnrollment.DateAdmitted >= tp.StartDate && currentEnrollment.DateAdmitted <= tp.EndDate);
								if (currentPeriod != null)
								{
									startGrantYear = currentPeriod.StartDate;
									endGrantYear = currentPeriod.EndDate;
								}
							}
							else
							{
								DateTime today = DateTime.Now;
								TimePeriod currentPeriod = context.TimePeriods.FirstOrDefault(tp => tp.StartDate.HasValue && tp.EndDate.HasValue &&
														   today >= tp.StartDate && today <= tp.EndDate);
								if (currentPeriod != null)
								{
									startGrantYear = currentPeriod.StartDate;
									endGrantYear = currentPeriod.EndDate;
								}
							}

							int hours = 0;
							foreach (ClassAttendance att in student.ClassAttendances.Where(ca => ca.Class.DateStart.HasValue && ca.Class.DateStart >= startGrantYear && ca.Class.DateStart <= endGrantYear))
							{
								if (att.Class.DateEnd.HasValue && att.Class.DateStart.HasValue)
								{
									TimeSpan? variable = att.Class.DateEnd - att.Class.DateStart;
									hours += variable.Value.Hours;
									if (hours >= 24)
									{
										isEligible = true;
										break;
									}
								}
							}
						}
						else
						{
							isEligible = true;
						}
					}
				}

				return isEligible;
			}
		}

		#region Staff

		/// <summary>
		/// gets all staff members
		/// </summary>
		/// <param name="key"></param>
		/// <returns></returns>
		public static List<StaffMember> GetAllStaff()
		{
			using (PODContext context = new PODContext())
			{
				return context.Persons.OfType<StaffMember>().OrderBy(c => c.LastName).ThenBy(c => c.FirstName).ToList();
			}

		}

		/// <summary>
		/// gets all staff members by site
		/// </summary>
		/// <param name="key"></param>
		/// <returns></returns>
		public static List<StaffMember> GetAllStaff(int? siteID)
		{
			using (PODContext context = new PODContext())
			{
				if (siteID.HasValue)
				{
					return context.Persons.OfType<StaffMember>().Include("StatusType").Where(c => c.LocationID.HasValue && (c.LocationID == siteID || (c.Location.SiteLocationID.HasValue && c.Location.SiteLocationID == siteID))).OrderBy(c => c.LastName).ThenBy(c => c.FirstName).ToList();
				}
				else
				{
					return context.Persons.OfType<StaffMember>().Include("StatusType").OrderBy(c => c.LastName).ThenBy(c => c.FirstName).ToList();
				}
			}
		}


		/// <summary>
		/// gets site id for staff member
		/// </summary>
		/// <param name="key"></param>
		/// <returns></returns>
		public static int GetSiteIDForStaff(int key)
		{
			int id = 0;
			using (PODContext context = new PODContext())
			{
				StaffMember person = context.Persons.OfType<StaffMember>().Include("Location").FirstOrDefault(c => c.PersonID == key);

				if (person.LocationID.HasValue)
				{
					if (person.Location.SiteLocationID.HasValue)
					{
						id = person.Location.SiteLocationID.Value;
					}
					else if (person.Location.IsSite)
					{
						id = person.LocationID.Value;
					}
				}
			}
			return id;
		}

		/// <summary>
		/// gets staff
		/// </summary>
		/// <param name="key"></param>
		/// <returns></returns>
		public static Person GetStaffByID(int key)
		{
			using (PODContext context = new PODContext())
			{
				return context.Persons.OfType<StaffMember>().Include(x => x.StatusType).Include(x => x.Addresses.Select(a => a.AddressType)).Include(x => x.PhoneNumbers).Include(x => x.Gender).FirstOrDefault(c => c.PersonID == key);
			}

		}

		/// <summary>
		/// deletes associated lesson plans 
		/// updates classes and course instances
		/// deletes the staff and person record
		/// 
		/// </summary>
		/// <param name="key"></param>
		/// <returns></returns>
		public static string DeleteStaff(int key, string username)
		{
			string result = string.Empty;

			using (PODContext context = new PODContext())
			{
				try
				{
					Person deletePerson = context.Persons.FirstOrDefault(p => p.PersonID == key);
					if (deletePerson != null)
					{
						//remove Instructor reference from class
						List<Class> classes = context.Classes.Where(c => c.InstructorPersonID.HasValue && c.InstructorPersonID.Value == key).ToList();
						foreach (Class cl in classes)
						{
							cl.InstructorPersonID = null;
						}
						//remove Assistant reference from class
						List<Class> classesAssistant = context.Classes.Where(c => c.AssistantPersonID.HasValue && c.AssistantPersonID.Value == key).ToList();
						foreach (Class cl in classesAssistant.Where(c => !classes.Any(cl => cl.ClassID == c.ClassID)))
						{
							cl.AssistantPersonID = null;
						}

						//remove Instructor reference from course instance
						List<CourseInstance> courseInstanceList = context.CourseInstances.Where(c => c.InstructorPersonID.HasValue && c.InstructorPersonID.Value == key).ToList();
						foreach (CourseInstance cl in courseInstanceList)
						{
							cl.InstructorPersonID = null;
						}
						//remove Assistant reference from course instance
						List<CourseInstance> courseInstanceListB = context.CourseInstances.Where(c => c.AssistantPersonID.HasValue && c.AssistantPersonID.Value == key).ToList();
						foreach (CourseInstance cl in courseInstanceListB.Where(c => !courseInstanceList.Any(cl => cl.CourseInstanceID == c.CourseInstanceID)))
						{
							cl.AssistantPersonID = null;
						}

						//remove Assistant reference from Lesson Plan
						List<LessonPlan> lpListb = context.LessonPlans.Where(c => c.AssistantPersonID.HasValue && c.AssistantPersonID.Value == key).ToList();
						foreach (CourseInstance cl in courseInstanceListB)
						{
							cl.AssistantPersonID = null;
						}
						//delete Lesson Plan
						List<LessonPlan> lpList = context.LessonPlans.Where(c => c.InstructorPersonID == key).ToList();
						foreach (LessonPlan cl in lpList)
						{
							context.LessonPlans.DeleteObject(cl);
						}

						Position pos = context.Positions.FirstOrDefault(p => p.PersonID.HasValue && p.PersonID.Value == deletePerson.PersonID);
						if (pos != null)
						{
							pos.PersonID = null;
						}

						StaffMember staffmember = deletePerson as StaffMember;
						staffmember.LastModifiedBy = username;
						context.Persons.DeleteObject(staffmember);
						context.SaveChanges();
					}

				}
				catch (Exception ex)
				{
					ex.Log();
					result = ex.Message;
				}
			}
			return result;
		}

		/// <summary>
		/// deletes associated lesson plans 
		/// updates classes and course instances
		/// deletes the staff and person record
		/// 
		/// </summary>
		/// <param name="key"></param>
		/// <returns></returns>
		public static int AddUpdateStaff(int key, int personTypeID, int statustypeid, string firstname, string lastname, string middlename, string email, string title, string company,
														string salutation, int? genderid, DateTime? dob, Guid userid, bool isActive, bool isAdmin, int? locid, DateTime? hiredate, DateTime? endDate, string currentUserName)
		{
			int personKey = 0;
			bool isAdd = false;
			using (PODContext context = new PODContext())
			{
				try
				{
					StaffMember originalPerson = null;

					if (key != 0)
					{
						originalPerson = context.Persons.OfType<StaffMember>().FirstOrDefault(p => p.PersonID == key);

					}
					if (originalPerson == null)
					{
						isAdd = true;
						originalPerson = new StaffMember();
						originalPerson.rowguid = Guid.NewGuid();
						personKey = originalPerson.PersonID;
						originalPerson.DateTimeStamp = DateTime.Now;

					}
					//set all properties
					originalPerson.PersonTypeID = personTypeID;
					originalPerson.StatusTypeID = statustypeid;
					originalPerson.GenderID = genderid;
					originalPerson.FirstName = firstname;
					originalPerson.LastName = lastname;
					originalPerson.MiddleName = middlename;
					originalPerson.Email = email;
					originalPerson.Title = title;
					originalPerson.CompanyName = company;
					originalPerson.Salutation = salutation;
					originalPerson.DateOfBirth = dob;
					originalPerson.IsActive = isActive;
					originalPerson.IsAdmin = isAdmin;
					originalPerson.LocationID = locid;
					originalPerson.UserID = userid;
					originalPerson.HireDate = hiredate;
					originalPerson.EndDate = endDate;

					originalPerson.LastModifiedBy = currentUserName;//always set
					if (isAdd)
					{
						context.Persons.AddObject(originalPerson);
					}

					context.SaveChanges();
					personKey = originalPerson.PersonID;

				}
				catch (Exception ex)
				{
					ex.Log();
					ex.Log();
				}
			}

			return personKey;

		}

		/// <summary>
		/// Adds or updates the position.
		/// </summary>
		/// <param name="key">The key.</param>
		/// <param name="isOpen">if set to <c>true</c> [is open].</param>
		/// <param name="locationId">The location id.</param>
		/// <param name="programId">The program id.</param>
		/// <param name="personId">The person id.</param>
		/// <param name="jobTitle">The job title.</param>
		/// <param name="vacancyDate">The vacancy date.</param>
		/// <param name="currentUserName">Name of the current user.</param>
		/// <returns></returns>
		public static int AddUpdatePosition(
			int key,
			bool isOpen,
			int? locationId,
			int programId,
			int? personId,
			string jobTitle,
			DateTime? vacancyDate,
			string currentUserName)
		{
			using (var context = new PODContext())
			{
				try
				{
					Position position = null;
					if (key > 0)
					{
						position = context.Positions
							.SingleOrDefault(x => x.PositionID == key);
					}
					if (position == null)
					{
						position = context.Positions.CreateObject();
						position.DateTimeStamp = DateTime.Now;
						context.Positions.AddObject(position);
					}

					position.LastModifiedBy = currentUserName;
					position.IsOpen = isOpen;
					position.LocationID = locationId > 0 ? locationId : null;
					position.ProgramID = programId;
					position.PersonID = personId > 0 ? personId : null;
					position.JobTitle = jobTitle;
					position.VacancyDate = vacancyDate > DateTime.MinValue ? vacancyDate : null;

					context.SaveChanges();
					return position.PositionID;
				}
				catch (Exception ex)
				{
					ex.Log();
					return 0;
					//TODO: Handle error message
				}
			}
		}

		/// <summary>
		/// Gets the positions by search.
		/// </summary>
		/// <param name="locationId">The location id.</param>
		/// <param name="programId">The program id.</param>
		/// <param name="personId">The person id.</param>
		/// <returns></returns>
		public static List<Position> GetPositionsBySearch(
			int? locationId = null,
			int? programId = null,
			int? personId = null)
		{
			using (var context = new PODContext())
			{
				return context.Positions
					.Include(x => x.Program)
					.Include(x => x.StaffMember)
					.Include(x => x.Location)
					.Where(
						x => (x.LocationID == locationId || locationId == 0 || locationId == null)
							 && (x.ProgramID == programId || programId == 0 || programId == null)
							 && (x.PersonID == personId || personId == 0 || personId == null))
					.ToList();
			}
		}

		/// <summary>
		/// Gets the position by ID.
		/// </summary>
		/// <param name="id">The id.</param>
		/// <returns></returns>
		public static Position GetPositionByID(int id)
		{
			using (var context = new PODContext())
			{
				return context.Positions
					.Include(x => x.Program)
					.Include(x => x.StaffMember)
					.Include(x => x.Location)
					.SingleOrDefault(x => x.PositionID == id);
			}
		}

		/// <summary>
		/// Deletes the position.
		/// </summary>
		/// <param name="id">The id.</param>
		/// <param name="message">The result message</param>
		/// <returns></returns>
		public static bool DeletePosition(int id, out string message)
		{
			using (var context = new PODContext())
			{
				try
				{
					var position = context.Positions.SingleOrDefault(x => x.PositionID == id);

					context.Positions.DeleteObject(position);
					context.SaveChanges();
					message = string.Empty;
					return true;
				}
				catch (Exception ex)
				{
					ex.Log();
					message = ex.Message;
					return false;
				}
			}
		}


		/// <summary>
		/// </summary>
		/// <param name="key"></param>
		/// <returns></returns>
		public static int AddUpdateStaff(int key, int personTypeID, string firstname, string lastname, string middlename, string email, string title, string company,
														string salutation, int? genderid, DateTime? dob, Guid userid, int? locid, string currentUserName)
		{
			int personKey = 0;
			bool isAdd = false;
			using (PODContext context = new PODContext())
			{
				try
				{
					StaffMember originalPerson = null;

					if (key != 0)
					{
						originalPerson = context.Persons.OfType<StaffMember>().FirstOrDefault(p => p.PersonID == key);

					}
					if (originalPerson == null)
					{
						isAdd = true;
						originalPerson = new StaffMember();
						originalPerson.rowguid = Guid.NewGuid();
						personKey = originalPerson.PersonID;
						originalPerson.DateTimeStamp = DateTime.Now;

					}
					//set all properties

					originalPerson.GenderID = genderid;
					originalPerson.FirstName = firstname;
					originalPerson.LastName = lastname;
					originalPerson.MiddleName = middlename;
					originalPerson.Email = email;
					originalPerson.Title = title;
					originalPerson.CompanyName = company;
					originalPerson.Salutation = salutation;
					originalPerson.DateOfBirth = dob;
					originalPerson.LocationID = locid;
					originalPerson.UserID = userid;

					originalPerson.LastModifiedBy = currentUserName;//always set
					if (isAdd)
					{
						context.Persons.AddObject(originalPerson);
					}

					context.SaveChanges();
					personKey = originalPerson.PersonID;

				}
				catch (Exception ex)
				{
					ex.Log();
				}
			}

			return personKey;

		}
		public static string UpdateUserName(Guid userid, string username)
		{
			using (PODContext context = new PODContext())
			{
				try
				{
					aspnet_User currentUser = context.aspnet_Users.FirstOrDefault(u => u.UserId == userid);
					if (currentUser != null)
					{
						currentUser.UserName = username;
						currentUser.LoweredUserName = username;
						context.SaveChanges();
					}
					return string.Empty;
				}
				catch (Exception ex)
				{
					ex.Log();
					return ex.Message;
				}
			}

		}
		#endregion

		public static List<Student> GetStudentsForCourseRegistration(int siteLocationID, DateTime registrationStartDate)
		{
			using (var context = new PODContext())
			{

				var grantyearName = string.Empty;

                switch (siteLocationID)
                {
					case 188:
					case 189:
					case 190: 
					case 191:
						grantyearName = "hc grant year";
						break;
                    default:
						grantyearName = "djj grant year";

						break;
                }


                var timePeriod = context.TimePeriods
										.FirstOrDefault(x => x.TimePeriodType.Name.ToLower() == grantyearName
															 && x.StartDate <= registrationStartDate
															 && x.EndDate >= registrationStartDate);
				var students =
					(from s in context.Persons.OfType<Student>().Where(s => s.StatusType.Name.ToLower() == "active")
					 join e in context.Enrollments on s.PersonID equals e.PersonID	
					 let dt = e.GrantYear ?? e.DateApplied
					 where dt >= timePeriod.StartDate //&& dt <= timePeriod.EndDate
						   && e.StatusType.Name.ToLower() == "enrolled"
						   && e.SiteLocationID == siteLocationID
						   && e.DateApplied != null 
					 orderby s.LastName, s.FirstName
					 select s).Distinct().OrderBy(o => o.LastName).ToList();


				//var result = students.Where(l => l.FirstName.ToLower() == "miles").FirstOrDefault();
				return students;
			}
		}

		
	}
}
