using System;
using System.Collections.Generic;
using System.Linq;
using System.Data.Entity;
using POD.Data.Entities;
using POD.Logging;

namespace POD.Data
{
    public static class TypesData
    {
        public enum Types
        {
            AddressType,
            AgeGroup,
            ClassType,
            CourseType,
            PersonalDevelopmentType,
            InventoryItemType,
            EnrollmentType,
            EventType,
            LessonPlanType,
            LocationType,
            LifeSkillType,
            PersonRelationshipType,
            PersonType,
            PhoneNumberType,
            ProgramType,
            ReferralType,
            ReferringAgencyType,
            StatusType,
            TimePeriod,
            TimePeriodType,
            LessonPlanSetTemplateType,
            NoteContactType

        }
        /// <summary>
        /// deletes specified type
        /// </summary>
        /// <param name="currentType">Type of ojb</param>
        /// <param name="key">Identifier</param>
        /// <returns>empty string or error message</returns>
        public static object GetTypeByTypeAndID(Types currentType, int key)
        {
            object result = null;
            using (PODContext context = new PODContext())
            {
                try
                {
                    switch (currentType)
                    {
                        case Types.AddressType:
                            result = context.AddressTypes.FirstOrDefault(k => k.AddressTypeID == key);
                            break;
                        case Types.ClassType:
                            result = context.ClassTypes.FirstOrDefault(k => k.ClassTypeID == key);
                            break;
                        case Types.CourseType:
                            result = context.CourseTypes.FirstOrDefault(k => k.CourseTypeID == key);
                            break;
                        case Types.PersonalDevelopmentType:
                            result = context.DisciplineTypes.FirstOrDefault(k => k.DisciplineTypeID == key);
                            break;
                        case Types.InventoryItemType:
                            result = context.InventoryItemTypes.FirstOrDefault(k => k.InventoryItemTypeID == key);
                            break;
                        case Types.EnrollmentType:
                            result = context.EnrollmentTypes.FirstOrDefault(k => k.EnrollmentTypeID == key);
                            break;
                        case Types.EventType:
                            result = context.EventTypes.FirstOrDefault(k => k.EventTypeID == key);
                            break;
                        case Types.LessonPlanType:
                            result = context.LessonPlanTypes.FirstOrDefault(k => k.LessonPlanTypeID == key);
                            break;
                        case Types.LifeSkillType:
                            result = context.LifeSkillTypes.FirstOrDefault(k => k.LifeSkillTypeID == key);
                            break;
                        case Types.LocationType:
                            result = context.LocationTypes.FirstOrDefault(k => k.LocationTypeID == key);
                            break;
                        case Types.PersonRelationshipType:
                            result = context.PersonRelationshipTypes.FirstOrDefault(k => k.PersonRelationshipTypeID == key);
                            break;
                        case Types.PersonType:
                            result = context.PersonTypes.FirstOrDefault(k => k.PersonTypeID == key);
                            break;
                        case Types.PhoneNumberType:
                            result = context.PhoneNumberTypes.FirstOrDefault(k => k.PhoneNumberTypeID == key);
                            break;
                        case Types.ProgramType:
                            result = context.ProgramTypes.FirstOrDefault(k => k.ProgramTypeID == key);
                            break;
                        case Types.ReferralType:
                            result = context.ReferralTypes.FirstOrDefault(k => k.ReferralTypeID == key);
                            break;
                        case Types.ReferringAgencyType:
                            result = context.ReferringAgencyTypes.FirstOrDefault(k => k.ReferringAgencyTypeID == key);
                            break;
                        case Types.StatusType:
                            result = context.StatusTypes.FirstOrDefault(k => k.StatusTypeID == key);
                            break;
                        case Types.TimePeriodType:
                            result = context.TimePeriodTypes.FirstOrDefault(k => k.TimePeriodTypeID == key);
                            break;
                        case Types.LessonPlanSetTemplateType:
                            result = context.LessonPlanSetTemplateTypes.FirstOrDefault(k => k.LessonPlanSetTemplateTypeId == key);
                            break;
                        case Types.NoteContactType:
                            result = context.NoteContactTypes.FirstOrDefault(k => k.NoteContactTypeID == key);
                            break;
                    }
                }
                catch (Exception ex)
                {
                    ex.Log();
                }
            }

            return result;
        }

        public static object GetTransportationPersonRelationshipTypesByType()
        {
            object result = null;
            using (PODContext context = new PODContext())
            {
                try
                {
                    result = context.PersonRelationshipTypes.Where(r => r.IsActive == false && r.isTransportation == true).ToList();
                }
                catch (Exception ex)
                {
                    ex.Log();
                }
            }

                    return result;
        }

        /// <summary>
        /// deletes specified type
        /// </summary>
        /// <param name="currentType">Type of ojb</param>
        /// <param name="key">Identifier</param>
        /// <returns>empty string or error message</returns>
        public static object GetTypesByType(Types currentType)
        {
            object result = null;
            using (PODContext context = new PODContext())
            {
                try
                {
                    switch (currentType)
                    {
                        case Types.AddressType:
                            result = context.AddressTypes.Where(r => r.IsActive).ToList();
                            break;
                        case Types.ClassType:
                            result = context.ClassTypes.Where(r => r.IsActive).ToList();
                            break;
                        case Types.CourseType:
                            result = context.CourseTypes.Where(r => r.IsActive).ToList();
                            break;
                        case Types.PersonalDevelopmentType:
                            result = context.DisciplineTypes.Where(r => r.IsActive).ToList();
                            break;
                        case Types.InventoryItemType:
                            result = context.InventoryItemTypes.Where(r => r.IsActive).ToList();
                            break;
                        case Types.EnrollmentType:
                            result = context.EnrollmentTypes.Where(r => r.IsActive).ToList();
                            break;
                        case Types.EventType:
                            result = context.EventTypes.Where(r => r.IsActive).ToList();
                            break;
                        case Types.LessonPlanType:
                            result = context.LessonPlanTypes.Where(r => r.IsActive).ToList();
                            break;
                        case Types.LifeSkillType:
                            result = context.LifeSkillTypes.Where(r => r.IsActive).ToList();
                            break;
                        case Types.LocationType:
                            result = context.LocationTypes.Where(r => r.IsActive).ToList();
                            break;
                        case Types.PersonRelationshipType:
                            result = context.PersonRelationshipTypes.Where(r => r.IsActive).ToList();
                            break;
                        case Types.PersonType:
                            result = context.PersonTypes.Where(r => r.IsActive).ToList();
                            break;
                        case Types.PhoneNumberType:
                            result = context.PhoneNumberTypes.Where(r => r.IsActive).ToList();
                            break;
                        case Types.ProgramType:
                            result = context.ProgramTypes.Where(r => r.IsActive).ToList();
                            break;
                        case Types.ReferralType:
                            result = context.ReferralTypes.Where(r => r.IsActive).ToList();
                            break;
                        case Types.ReferringAgencyType:
                            result = context.ReferringAgencyTypes.Where(r => r.IsActive).ToList();
                            break;
                        case Types.StatusType:
                            result = context.StatusTypes.Where(r => r.IsActive).ToList();
                            break;
                        case Types.TimePeriodType:
                            result = context.TimePeriodTypes.Where(r => r.IsActive).ToList();
                            break;
                        case Types.LessonPlanSetTemplateType:
                            result = context.LessonPlanSetTemplateTypes.Where(r => r.IsActive).ToList();
                            break;
                        case Types.NoteContactType:
                            result = context.NoteContactTypes.Where(r => r.IsActive).ToList();
                            break;
                    }
                }
                catch (Exception ex)
                {
                    ex.Log();
                }
            }

            return result;
        }

        /// <summary>
        /// retrieves the identifer for an option
        /// in a specified type object
        /// </summary>
        /// <param name="currentType">Type of ojb</param>
        /// <param name="key">Identifier</param>
        /// <returns>empty string or error message</returns>
        public static int GetTypeIDByName(Types currentType, string name)
        {
            int typeID = 0;
            using (PODContext context = new PODContext())
            {
                try
                {
                    switch (currentType)
                    {
                        case Types.AddressType:
                            AddressType type = context.AddressTypes.FirstOrDefault(a => a.Name.ToLower().Contains(name));
                            if (type != null)
                            {
                                typeID = type.AddressTypeID;
                            }
                            break;
                        case Types.ClassType:
                            ClassType ctype = context.ClassTypes.FirstOrDefault(c => c.Name.ToLower().Contains(name));
                            if (ctype != null)
                            {
                                typeID = ctype.ClassTypeID;
                            }
                            break;
                        case Types.CourseType:
                            CourseType csType = context.CourseTypes.FirstOrDefault(c => c.Name.ToLower().Contains(name));
                            if (csType != null)
                            {
                                typeID = csType.CourseTypeID;
                            }
                            break;
                        case Types.PersonalDevelopmentType:
                            DisciplineType disType = context.DisciplineTypes.FirstOrDefault(c => c.Name.ToLower().Contains(name));
                            if (disType != null)
                            {
                                typeID = disType.DisciplineTypeID;
                            }
                            break;
                        case Types.InventoryItemType:
                            InventoryItemType invType = context.InventoryItemTypes.FirstOrDefault(c => c.Name.ToLower().Contains(name));
                            if (invType != null)
                            {
                                typeID = invType.InventoryItemTypeID;
                            }
                            break;
                        case Types.EnrollmentType:
                            EnrollmentType enType = context.EnrollmentTypes.FirstOrDefault(c => c.Name.ToLower().Contains(name));
                            if (enType != null)
                            {
                                typeID = enType.EnrollmentTypeID;
                            }
                            break;
                        case Types.EventType:
                            EventType evType = context.EventTypes.FirstOrDefault(c => c.Name.ToLower().Contains(name));
                            if (evType != null)
                            {
                                typeID = evType.EventTypeID;
                            }
                            break;
                        case Types.LessonPlanType:
                            LessonPlanType lessType = context.LessonPlanTypes.FirstOrDefault(c => c.Name.ToLower().Contains(name));
                            if (lessType != null)
                            {
                                typeID = lessType.LessonPlanTypeID;
                            }
                            break;
                        case Types.LifeSkillType:
                            LifeSkillType lifeType = context.LifeSkillTypes.FirstOrDefault(c => c.Name.ToLower().Contains(name));
                            if (lifeType != null)
                            {
                                typeID = lifeType.LifeSkillTypeID;
                            }
                            break;
                        case Types.LocationType:
                            LocationType locType = context.LocationTypes.FirstOrDefault(c => c.Name.ToLower().Contains(name));
                            if (locType != null)
                            {
                                typeID = locType.LocationTypeID;
                            }
                            break;
                        case Types.PersonRelationshipType:
                            PersonRelationshipType relType = context.PersonRelationshipTypes.FirstOrDefault(c => c.Name.ToLower().StartsWith(name));
                            if (relType != null)
                            {
                                typeID = relType.PersonRelationshipTypeID;
                            }
                            break;
                        case Types.PersonType:
                            PersonType ppType = context.PersonTypes.FirstOrDefault(c => c.Name.ToLower().Contains(name));
                            if (ppType != null)
                            {
                                typeID = ppType.PersonTypeID;
                            }
                            break;
                        case Types.PhoneNumberType:
                            PhoneNumberType phoneType = context.PhoneNumberTypes.FirstOrDefault(c => c.Name.ToLower().Contains(name));
                            if (phoneType != null)
                            {
                                typeID = phoneType.PhoneNumberTypeID;
                            }
                            break;
                        case Types.ProgramType:
                            ProgramType progType = context.ProgramTypes.FirstOrDefault(c => c.Name.ToLower().Contains(name));
                            if (progType != null)
                            {
                                typeID = progType.ProgramTypeID;
                            }
                            break;
                        case Types.ReferralType:
                            ReferralType refType = context.ReferralTypes.FirstOrDefault(c => c.Name.ToLower().Contains(name));
                            if (refType != null)
                            {
                                typeID = refType.ReferralTypeID;
                            }
                            break;
                        case Types.ReferringAgencyType:
                            ReferringAgencyType agenType = context.ReferringAgencyTypes.FirstOrDefault(c => c.Name.ToLower().Contains(name));
                            if (agenType != null)
                            {
                                typeID = agenType.ReferringAgencyTypeID;
                            }
                            break;
                        case Types.StatusType:
                            StatusType stType = context.StatusTypes.FirstOrDefault(c => c.Name.ToLower().Contains(name));
                            if (stType != null)
                            {
                                typeID = stType.StatusTypeID;
                            }
                            break;
                        case Types.TimePeriodType:
                            TimePeriodType tpType = context.TimePeriodTypes.FirstOrDefault(c => c.Name.ToLower().Contains(name));
                            if (tpType != null)
                            {
                                typeID = tpType.TimePeriodTypeID;
                            }
                            break;
                        case Types.LessonPlanSetTemplateType:
                            LessonPlanSetTemplateType lpstType = context.LessonPlanSetTemplateTypes.FirstOrDefault(c => c.Name.ToLower().Contains(name));
                            if (lpstType != null)
                            {
                                typeID = lpstType.LessonPlanSetTemplateTypeId;
                            }
                            break;
                        case Types.NoteContactType:
                            NoteContactType nctType = context.NoteContactTypes.FirstOrDefault(c => c.Name.ToLower().Contains(name));
                            if (nctType != null)
                            {
                                typeID = nctType.NoteContactTypeID;
                            }
                            break;
                    }
                }
                catch (Exception ex)
                {
                    ex.Log();
                }
            }

            return typeID;
        }

        /// <summary>
        /// retrieves status types by category
        /// </summary>
        /// <param name="currentType">Type of obj</param>
        /// <param name="Category">Category</param>
        /// <returns>List or null</returns>
        public static List<StatusType> GetStatusTypesByCategory(string category)
        {
            using (PODContext context = new PODContext())
            {
                try
                {
                    return context.StatusTypes.Where(c => c.Category == category).ToList();
                }
                catch (Exception ex)
                {
                    ex.Log();
                    return null;
                }
            }
        }


        /// <summary>
        /// retrieves status type by category
        /// </summary>
        /// <param name="currentType">Type of obj</param>
        /// <param name="Category">Category</param>
        /// <returns>List or null</returns>
        public static StatusType GetStatusTypeByCategoryAndName(string category, string name)
        {
            using (PODContext context = new PODContext())
            {
                try
                {
                    return context.StatusTypes.Where(c => c.Category == category).FirstOrDefault(c => c.Name.ToLower().Contains(name));
                }
                catch (Exception ex)
                {
                    ex.Log();
                    return null;
                }
            }
        }

        /// <summary>
        /// takes in parameters to be updated or used to create new object.
        /// also takes in what type to add/update
        /// </summary>
        /// <param name="currentType">Type of ojb</param>
        /// <param name="name">name</param>
        /// <param name="desc">Description</param>
        /// <param name="status">Status</param>
        /// <param name="key">Identifier</param>
        /// <returns>empty string or error message</returns>
        public static string AddUpdateType(Types currentType, string name, string desc, bool status, int key, string category)
        {
            string result = string.Empty;
            using (PODContext context = new PODContext())
            {
                try
                {
                    switch (currentType)
                    {
                        case Types.AddressType:
                            AddressType originalAddressType = context.AddressTypes.FirstOrDefault(k => k.AddressTypeID == key);
                            if (originalAddressType != null)
                            {
                                originalAddressType.Name = name;
                                originalAddressType.Description = desc;
                                originalAddressType.IsActive = status;
                            }
                            else
                            {
                                originalAddressType = new AddressType();
                                originalAddressType.rowguid = Guid.NewGuid();
                                originalAddressType.DateTimeStamp = DateTime.Now;
                                originalAddressType.Name = name;
                                originalAddressType.Description = desc;
                                originalAddressType.IsActive = status;
                                context.AddressTypes.AddObject(originalAddressType);
                            }
                            context.SaveChanges();
                            break;
                        case Types.ClassType:
                            ClassType originalType = context.ClassTypes.FirstOrDefault(k => k.ClassTypeID == key);
                            if (originalType != null)
                            {
                                originalType.Name = name;
                                originalType.Description = desc;
                                originalType.IsActive = status;
                            }
                            else
                            {
                                originalType = new ClassType();
                                originalType.rowguid = Guid.NewGuid();
                                originalType.DateTimeStamp = DateTime.Now;
                                originalType.Name = name;
                                originalType.Description = desc;
                                originalType.IsActive = status;
                                context.ClassTypes.AddObject(originalType);
                            }
                            context.SaveChanges();
                            break;
                        case Types.CourseType:
                            CourseType originalCourseType = context.CourseTypes.FirstOrDefault(k => k.CourseTypeID == key);
                            if (originalCourseType != null)
                            {
                                originalCourseType.Name = name;
                                originalCourseType.Description = desc;
                                originalCourseType.IsActive = status;
                            }
                            else
                            {
                                originalCourseType = new CourseType();
                                originalCourseType.rowguid = Guid.NewGuid();
                                originalCourseType.DateTimeStamp = DateTime.Now;
                                originalCourseType.Name = name;
                                originalCourseType.Description = desc;
                                originalCourseType.IsActive = status;
                                context.CourseTypes.AddObject(originalCourseType);
                            }
                            context.SaveChanges();
                            break;
                        case Types.PersonalDevelopmentType:
                            DisciplineType originaldisType = context.DisciplineTypes.FirstOrDefault(k => k.DisciplineTypeID == key);
                            if (originaldisType != null)
                            {
                                originaldisType.Name = name;
                                originaldisType.Description = desc;
                                originaldisType.IsActive = status;
                            }
                            else
                            {
                                originaldisType = new DisciplineType();
                                originaldisType.rowguid = Guid.NewGuid();
                                originaldisType.DateTimeStamp = DateTime.Now;
                                originaldisType.Name = name;
                                originaldisType.Description = desc;
                                originaldisType.IsActive = status;
                                context.DisciplineTypes.AddObject(originaldisType);
                            }
                            context.SaveChanges();
                            break;
                        case Types.InventoryItemType:
                            InventoryItemType originalInvType = context.InventoryItemTypes.FirstOrDefault(k => k.InventoryItemTypeID == key);
                            if (originalInvType != null)
                            {
                                originalInvType.Name = name;
                                originalInvType.Description = desc;
                                originalInvType.IsActive = status;
                            }
                            else
                            {
                                originalInvType = new InventoryItemType();
                                originalInvType.rowguid = Guid.NewGuid();
                                originalInvType.DateTimeStamp = DateTime.Now;
                                originalInvType.Name = name;
                                originalInvType.Description = desc;
                                originalInvType.IsActive = status;
                                context.InventoryItemTypes.AddObject(originalInvType);
                            }
                            context.SaveChanges();
                            break;
                        case Types.EnrollmentType:
                            EnrollmentType origEnrollmentType = context.EnrollmentTypes.FirstOrDefault(k => k.EnrollmentTypeID == key);
                            if (origEnrollmentType != null)
                            {
                                origEnrollmentType.Name = name;
                                origEnrollmentType.Description = desc;
                                origEnrollmentType.IsActive = status;
                            }
                            else
                            {
                                origEnrollmentType = new EnrollmentType();
                                origEnrollmentType.rowguid = Guid.NewGuid();
                                origEnrollmentType.DateTimeStamp = DateTime.Now;
                                origEnrollmentType.Name = name;
                                origEnrollmentType.Description = desc;
                                origEnrollmentType.IsActive = status;
                                context.EnrollmentTypes.AddObject(origEnrollmentType);
                            }
                            context.SaveChanges();
                            break;
                        case Types.EventType:
                            EventType origEventType = context.EventTypes.FirstOrDefault(k => k.EventTypeID == key);
                            if (origEventType != null)
                            {
                                origEventType.Name = name;
                                origEventType.Description = desc;
                                origEventType.IsActive = status;
                            }
                            else
                            {
                                origEventType = new EventType();
                                origEventType.rowguid = Guid.NewGuid();
                                origEventType.DateTimeStamp = DateTime.Now;
                                origEventType.Name = name;
                                origEventType.Description = desc;
                                origEventType.IsActive = status;
                                context.EventTypes.AddObject(origEventType);
                            }
                            context.SaveChanges();
                            break;
                        case Types.LessonPlanType:
                            LessonPlanType origLessonType = context.LessonPlanTypes.FirstOrDefault(k => k.LessonPlanTypeID == key);
                            if (origLessonType != null)
                            {
                                origLessonType.Name = name;
                                origLessonType.Description = desc;
                                origLessonType.IsActive = status;
                            }
                            else
                            {
                                origLessonType = new LessonPlanType();
                                origLessonType.rowguid = Guid.NewGuid();
                                origLessonType.DateTimeStamp = DateTime.Now;
                                origLessonType.Name = name;
                                origLessonType.Description = desc;
                                origLessonType.IsActive = status;
                                context.LessonPlanTypes.AddObject(origLessonType);
                            }
                            context.SaveChanges();
                            break;
                        case Types.LifeSkillType:
                            LifeSkillType origlifeType = context.LifeSkillTypes.FirstOrDefault(k => k.LifeSkillTypeID == key);
                            if (origlifeType != null)
                            {
                                origlifeType.Name = name;
                                origlifeType.Description = desc;
                                origlifeType.IsActive = status;
                            }
                            else
                            {
                                origlifeType = new LifeSkillType();
                                origlifeType.rowguid = Guid.NewGuid();
                                origlifeType.DateTimeStamp = DateTime.Now;
                                origlifeType.Name = name;
                                origlifeType.Description = desc;
                                origlifeType.IsActive = status;
                                context.LifeSkillTypes.AddObject(origlifeType);
                            }
                            context.SaveChanges();
                            break;
                        case Types.LocationType:
                            LocationType origLocationType = context.LocationTypes.FirstOrDefault(k => k.LocationTypeID == key);
                            if (origLocationType != null)
                            {
                                origLocationType.Name = name;
                                origLocationType.Description = desc;
                                origLocationType.IsActive = status;
                            }
                            else
                            {
                                origLocationType = new LocationType();
                                origLocationType.rowguid = Guid.NewGuid();
                                origLocationType.DateTimeStamp = DateTime.Now;
                                origLocationType.Name = name;
                                origLocationType.Description = desc;
                                origLocationType.IsActive = status;
                                context.LocationTypes.AddObject(origLocationType);
                            }
                            context.SaveChanges();
                            break;
                        case Types.PersonRelationshipType:
                            PersonRelationshipType origRelationType = context.PersonRelationshipTypes.FirstOrDefault(k => k.PersonRelationshipTypeID == key);
                            if (origRelationType != null)
                            {
                                origRelationType.Name = name;
                                origRelationType.Description = desc;
                                origRelationType.IsActive = status;
                            }
                            else
                            {
                                origRelationType = new PersonRelationshipType();
                                origRelationType.rowguid = Guid.NewGuid();
                                origRelationType.DateTimeStamp = DateTime.Now;
                                origRelationType.Name = name;
                                origRelationType.Description = desc;
                                origRelationType.IsActive = status;
                                context.PersonRelationshipTypes.AddObject(origRelationType);
                            }
                            context.SaveChanges();
                            break;
                        case Types.PersonType:
                            PersonType origPersonType = context.PersonTypes.FirstOrDefault(k => k.PersonTypeID == key);
                            if (origPersonType != null)
                            {
                                origPersonType.Name = name;
                                origPersonType.Description = desc;
                                origPersonType.IsActive = status;
                            }
                            else
                            {
                                origPersonType = new PersonType();
                                origPersonType.rowguid = Guid.NewGuid();
                                origPersonType.DateTimeStamp = DateTime.Now;
                                origPersonType.Name = name;
                                origPersonType.Description = desc;
                                origPersonType.IsActive = status;
                                context.PersonTypes.AddObject(origPersonType);
                            }
                            context.SaveChanges();
                            break;
                        case Types.PhoneNumberType:
                            PhoneNumberType origPhoneType = context.PhoneNumberTypes.FirstOrDefault(k => k.PhoneNumberTypeID == key);
                            if (origPhoneType != null)
                            {
                                origPhoneType.Name = name;
                                origPhoneType.Description = desc;
                                origPhoneType.IsActive = status;
                            }
                            else
                            {
                                origPhoneType = new PhoneNumberType();
                                origPhoneType.rowguid = Guid.NewGuid();
                                origPhoneType.DateTimeStamp = DateTime.Now;
                                origPhoneType.Name = name;
                                origPhoneType.Description = desc;
                                origPhoneType.IsActive = status;
                                context.PhoneNumberTypes.AddObject(origPhoneType);
                            }
                            context.SaveChanges();
                            break;
                        case Types.ProgramType:
                            ProgramType origProgramType = context.ProgramTypes.FirstOrDefault(k => k.ProgramTypeID == key);
                            if (origProgramType != null)
                            {
                                origProgramType.Name = name;
                                origProgramType.Description = desc;
                                origProgramType.IsActive = status;
                            }
                            else
                            {
                                origProgramType = new ProgramType();
                                origProgramType.rowguid = Guid.NewGuid();
                                origProgramType.DateTimeStamp = DateTime.Now;
                                origProgramType.Name = name;
                                origProgramType.Description = desc;
                                origProgramType.IsActive = status;
                                context.ProgramTypes.AddObject(origProgramType);
                            }
                            context.SaveChanges();
                            break;
                        case Types.ReferralType:
                            ReferralType origReferralType = context.ReferralTypes.FirstOrDefault(k => k.ReferralTypeID == key);
                            if (origReferralType != null)
                            {
                                origReferralType.Name = name;
                                origReferralType.Description = desc;
                                origReferralType.IsActive = status;
                            }
                            else
                            {
                                origReferralType = new ReferralType();
                                origReferralType.rowguid = Guid.NewGuid();
                                origReferralType.DateTimeStamp = DateTime.Now;
                                origReferralType.Name = name;
                                origReferralType.Description = desc;
                                origReferralType.IsActive = status;
                                context.ReferralTypes.AddObject(origReferralType);
                            }
                            context.SaveChanges();
                            break;
                        case Types.ReferringAgencyType:
                            ReferringAgencyType origReferringAgencyType = context.ReferringAgencyTypes.FirstOrDefault(k => k.ReferringAgencyTypeID == key);
                            if (origReferringAgencyType != null)
                            {
                                origReferringAgencyType.Name = name;
                                origReferringAgencyType.Description = desc;
                                origReferringAgencyType.IsActive = status;
                            }
                            else
                            {
                                origReferringAgencyType = new ReferringAgencyType();
                                origReferringAgencyType.rowguid = Guid.NewGuid();
                                origReferringAgencyType.DateTimeStamp = DateTime.Now;
                                origReferringAgencyType.Name = name;
                                origReferringAgencyType.Description = desc;
                                origReferringAgencyType.IsActive = status;
                                context.ReferringAgencyTypes.AddObject(origReferringAgencyType);
                            }
                            context.SaveChanges();
                            break;
                        case Types.StatusType:
                            StatusType origStatusType = context.StatusTypes.FirstOrDefault(k => k.StatusTypeID == key);
                            if (origStatusType != null)
                            {
                                origStatusType.Name = name;
                                origStatusType.Description = desc;
                                origStatusType.IsActive = status;
                                origStatusType.Category = category;
                            }
                            else
                            {
                                origStatusType = new StatusType();
                                origStatusType.rowguid = Guid.NewGuid();
                                origStatusType.DateTimeStamp = DateTime.Now;
                                origStatusType.Name = name;
                                origStatusType.Description = desc;
                                origStatusType.IsActive = status;
                                origStatusType.Category = category;
                                context.StatusTypes.AddObject(origStatusType);
                            }
                            context.SaveChanges();
                            break;
                        case Types.TimePeriodType:
                            TimePeriodType origTimePeriodType = context.TimePeriodTypes.FirstOrDefault(k => k.TimePeriodTypeID == key);
                            if (origTimePeriodType != null)
                            {
                                origTimePeriodType.Name = name;
                                origTimePeriodType.Description = desc;
                                origTimePeriodType.IsActive = status;
                            }
                            else
                            {
                                origTimePeriodType = new TimePeriodType();
                                origTimePeriodType.rowguid = Guid.NewGuid();
                                origTimePeriodType.DateTimeStamp = DateTime.Now;
                                origTimePeriodType.Name = name;
                                origTimePeriodType.Description = desc;
                                origTimePeriodType.IsActive = status;
                                context.TimePeriodTypes.AddObject(origTimePeriodType);
                            }
                            context.SaveChanges();
                            break;
                        case Types.NoteContactType:
                            NoteContactType onoteContactType = context.NoteContactTypes.FirstOrDefault(k => k.NoteContactTypeID == key);
                            if (onoteContactType != null)
                            {
                                onoteContactType.Name = name;
                                onoteContactType.Description = desc;
                                onoteContactType.IsActive = status;
                            }
                            else
                            {
                                onoteContactType = new NoteContactType();
                                onoteContactType.rowguid = Guid.NewGuid();
                                onoteContactType.DateTimeStamp = DateTime.Now;
                                onoteContactType.Name = name;
                                onoteContactType.Description = desc;
                                onoteContactType.IsActive = status;
                                context.NoteContactTypes.AddObject(onoteContactType);
                            }
                            context.SaveChanges();
                            break;
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
        /// deletes specified type
        /// </summary>
        /// <param name="currentType">Type of ojb</param>
        /// <param name="key">Identifier</param>
        /// <returns>empty string or error message</returns>
        public static string DeleteType(Types currentType, int key)
        {
            string result = string.Empty;
            using (PODContext context = new PODContext())
            {
                try
                {
                    switch (currentType)
                    {
                        case Types.AddressType:
                            AddressType originalAddressType = context.AddressTypes.FirstOrDefault(k => k.AddressTypeID == key);
                            if (originalAddressType != null)
                            {
                                context.AddressTypes.DeleteObject(originalAddressType);
                            }

                            context.SaveChanges();
                            break;
                        case Types.ClassType:
                            ClassType originalType = context.ClassTypes.FirstOrDefault(k => k.ClassTypeID == key);
                            if (originalType != null)
                            {
                                context.ClassTypes.DeleteObject(originalType);
                                context.SaveChanges();
                            }
                            break;
                        case Types.CourseType:
                            CourseType originalCourseType = context.CourseTypes.FirstOrDefault(k => k.CourseTypeID == key);
                            if (originalCourseType != null)
                            {
                                context.CourseTypes.DeleteObject(originalCourseType);
                                context.SaveChanges();
                            }
                            break;
                        case Types.PersonalDevelopmentType:
                            DisciplineType originaldisType = context.DisciplineTypes.FirstOrDefault(k => k.DisciplineTypeID == key);
                            if (originaldisType != null)
                            {
                                context.DisciplineTypes.DeleteObject(originaldisType);
                                context.SaveChanges();
                            }
                            break;
                        case Types.InventoryItemType:
                            InventoryItemType originalInvType = context.InventoryItemTypes.FirstOrDefault(k => k.InventoryItemTypeID == key);
                            if (originalInvType != null)
                            {
                                context.InventoryItemTypes.DeleteObject(originalInvType);
                                context.SaveChanges();
                            }
                            break;
                        case Types.EnrollmentType:
                            EnrollmentType origEnrollmentType = context.EnrollmentTypes.FirstOrDefault(k => k.EnrollmentTypeID == key);
                            if (origEnrollmentType != null)
                            {
                                context.EnrollmentTypes.DeleteObject(origEnrollmentType);
                                context.SaveChanges();
                            }
                            break;
                        case Types.EventType:
                            EventType origEventType = context.EventTypes.FirstOrDefault(k => k.EventTypeID == key);
                            if (origEventType != null)
                            {
                                context.EventTypes.DeleteObject(origEventType);
                                context.SaveChanges();
                            }
                            break;
                        case Types.LessonPlanType:
                            LessonPlanType origLessonType = context.LessonPlanTypes.FirstOrDefault(k => k.LessonPlanTypeID == key);
                            if (origLessonType != null)
                            {
                                context.LessonPlanTypes.DeleteObject(origLessonType);
                                context.SaveChanges();
                            }
                            break;
                        case Types.LifeSkillType:
                            LifeSkillType origLifeType = context.LifeSkillTypes.FirstOrDefault(k => k.LifeSkillTypeID == key);
                            if (origLifeType != null)
                            {
                                context.LifeSkillTypes.DeleteObject(origLifeType);
                                context.SaveChanges();
                            }
                            break;
                        case Types.LocationType:
                            LocationType origLocationType = context.LocationTypes.FirstOrDefault(k => k.LocationTypeID == key);
                            if (origLocationType != null)
                            {
                                context.LocationTypes.DeleteObject(origLocationType);
                                context.SaveChanges();
                            }
                            break;
                        case Types.PersonRelationshipType:
                            PersonRelationshipType origRelationType = context.PersonRelationshipTypes.FirstOrDefault(k => k.PersonRelationshipTypeID == key);
                            if (origRelationType != null)
                            {
                                context.PersonRelationshipTypes.DeleteObject(origRelationType);
                                context.SaveChanges();
                            }
                            break;
                        case Types.PersonType:
                            PersonType origPersonType = context.PersonTypes.FirstOrDefault(k => k.PersonTypeID == key);
                            if (origPersonType != null)
                            {
                                context.PersonTypes.DeleteObject(origPersonType);
                                context.SaveChanges();
                            }
                            break;
                        case Types.PhoneNumberType:
                            PhoneNumberType origPhoneType = context.PhoneNumberTypes.FirstOrDefault(k => k.PhoneNumberTypeID == key);
                            if (origPhoneType != null)
                            {
                                context.PhoneNumberTypes.DeleteObject(origPhoneType);
                                context.SaveChanges();
                            }
                            break;
                        case Types.ProgramType:
                            ProgramType origProgramType = context.ProgramTypes.FirstOrDefault(k => k.ProgramTypeID == key);
                            if (origProgramType != null)
                            {
                                context.ProgramTypes.DeleteObject(origProgramType);
                                context.SaveChanges();
                            }
                            break;
                        case Types.ReferralType:
                            ReferralType origReferralType = context.ReferralTypes.FirstOrDefault(k => k.ReferralTypeID == key);
                            if (origReferralType != null)
                            {
                                context.ReferralTypes.DeleteObject(origReferralType);
                                context.SaveChanges();
                            }
                            break;
                        case Types.ReferringAgencyType:
                            ReferringAgencyType origReferringAgencyType = context.ReferringAgencyTypes.FirstOrDefault(k => k.ReferringAgencyTypeID == key);
                            if (origReferringAgencyType != null)
                            {
                                context.ReferringAgencyTypes.DeleteObject(origReferringAgencyType);
                                context.SaveChanges();
                            }
                            break;
                        case Types.StatusType:
                            StatusType origStatusType = context.StatusTypes.FirstOrDefault(k => k.StatusTypeID == key);
                            if (origStatusType != null)
                            {
                                context.StatusTypes.DeleteObject(origStatusType);
                                context.SaveChanges();
                            }
                            break;
                        case Types.TimePeriodType:
                            TimePeriodType origtpType = context.TimePeriodTypes.FirstOrDefault(k => k.TimePeriodTypeID == key);
                            if (origtpType != null)
                            {
                                context.TimePeriodTypes.DeleteObject(origtpType);
                                context.SaveChanges();
                            }
                            break;
                        case Types.NoteContactType:
                            NoteContactType ncType = context.NoteContactTypes.FirstOrDefault(k => k.NoteContactTypeID == key);
                            if (ncType != null)
                            {
                                context.NoteContactTypes.DeleteObject(ncType);
                                context.SaveChanges();
                            }
                            break;
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

        #region AgeGroup

        public static List<AgeGroup> GetAgeGroups()
        {
            using (PODContext context = new PODContext())
            {
                return context.AgeGroups.Where(r => r.IsActive == true).OrderBy(a => a.Name).ToList();
            }
        }

        public static List<AgeGroup> GetAllAgeGroups()
        {
            using (PODContext context = new PODContext())
            {
                return context.AgeGroups.OrderBy(a => a.Name).ToList();
            }
        }

        public static string AddUpdateAgeGroup(string name, int minimumAge, int maximumAge, int key)
        {
            string result = string.Empty;
            bool isadd = false;
            using (PODContext context = new PODContext())
            {
                try
                {
                    AgeGroup origGroup = context.AgeGroups.FirstOrDefault(a => a.AgeGroupID == key);
                    if (origGroup == null)
                    {
                        isadd = true;
                        origGroup = new AgeGroup();
                        origGroup.rowguid = Guid.NewGuid();
                        origGroup.DateTimeStamp = DateTime.Now;
                    }
                    origGroup.Name = name;
                    origGroup.AgeMinimum = minimumAge;
                    origGroup.AgeMaximum = maximumAge;
                    if (isadd)
                    {
                        context.AgeGroups.AddObject(origGroup);
                    }
                    context.SaveChanges();

                }
                catch (Exception ex)
                {
                    ex.Log();
                    result = ex.Message;
                }
                return result;
            }
        }

        public static string DeleteAgeGroup(int key)
        {
            string result = string.Empty;
            using (PODContext context = new PODContext())
            {
                try
                {
                    AgeGroup gr = context.AgeGroups.FirstOrDefault(a => a.AgeGroupID == key);
                    if (gr != null)
                    {
                        context.AgeGroups.DeleteObject(gr);
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
        #endregion

        #region Time Periods
        public static List<TimePeriod> GetTimePeriods()
        {
            using (PODContext context = new PODContext())
            {
                return context.TimePeriods.Include(x => x.TimePeriodType).OrderBy(a => a.EndDate).ToList();
            }
        }

        public static string AddUpdateTimePeriod(int timeperiodTypeid, DateTime? startDate, DateTime? endDate, int key)
        {
            string result = string.Empty;
            bool isadd = false;
            using (PODContext context = new PODContext())
            {
                try
                {
                    TimePeriod origGroup = context.TimePeriods.FirstOrDefault(a => a.TimePeriodID == key);
                    if (origGroup == null)
                    {
                        isadd = true;
                        origGroup = new TimePeriod();
                        origGroup.rowguid = Guid.NewGuid();
                        origGroup.DateTimeStamp = DateTime.Now;
                    }
                    origGroup.TimePeriodTypeID = timeperiodTypeid;
                    origGroup.StartDate = startDate;
                    origGroup.EndDate = endDate;
                    if (isadd)
                    {
                        context.TimePeriods.AddObject(origGroup);
                    }
                    context.SaveChanges();

                }
                catch (Exception ex)
                {
                    ex.Log();
                    result = ex.Message;
                }
                return result;
            }
        }

        public static string DeleteTimePeriod(int key)
        {
            string result = string.Empty;
            using (PODContext context = new PODContext())
            {
                try
                {
                    TimePeriod gr = context.TimePeriods.FirstOrDefault(a => a.TimePeriodID == key);
                    if (gr != null)
                    {
                        context.TimePeriods.DeleteObject(gr);
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
        #endregion

    }//class

}//namespace
