using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using POD.Data.Entities;

namespace POD.Logic
{
    public static class PATFormLogic
    {
        public static List<FormSection> GetFormSections(int formId)
        {
            return POD.Data.PATFormData.GetFormSections(formId);
        }

        public static bool DoesInitialPATExist(int personId)
        {
            return POD.Data.PATFormData.DoesInitialPATExist(personId);
        }

        public static bool DoesExitPATExist(int personId)
        {
            return POD.Data.PATFormData.DoesExitPATExist(personId);
        }

        public static List<PersonForm> GetPersonForms(int personId)
        {
            return POD.Data.PATFormData.GetPersonForms(personId);
        }

        public static PersonForm GetPersonForm(int personFormId)
        {
            return POD.Data.PATFormData.GetPersonForm(personFormId);
        }

        
        public static PersonForm GetExitPersonFormByPersonid(int personId)
        {
            return POD.Data.PATFormData.GetExitPersonFormByPersonid(personId);
        }

        public static void DeletePersonForm(int personFormId)
        {
            POD.Data.PATFormData.DeletePersonForm(personFormId);
        }

        public static void UpdateAppliedDateForEnrollment(int personId, DateTime completedPATDate)
        {
            POD.Data.EnrollmentData.UpdateEnrollmentAppliedDate(personId, completedPATDate);
        }

        public static List<FormQuestion> GetFormSectionQuestions(int sectionId)
        {
            return POD.Data.PATFormData.GetFormSectionQuestions(sectionId);
        }

        public static List<FormQuestion> GetFormQuestions(int formId)
        {
            return POD.Data.PATFormData.GetFormQuestions(formId);
        }

        public static List<FormQuestionChoice> GetFormQuestionChoices(int personFormId, int questionId)
        {
            return POD.Data.PATFormData.GetQuestionChoices(personFormId, questionId);
        }

        public static bool IsFormQuestionChoiceClickAllChecked(int personFormId, int questionId, int choiceId)
        {
            return POD.Data.PATFormData.IsFormQuestionChoiceClickAllChecked(personFormId, questionId, choiceId);
        }

        public static PersonForm SavePersonForm(PersonForm pf, string userName)
        {
            return POD.Data.PATFormData.AddUpdatePersonForm(pf, userName);
        }

        public static int SaveQuestion(int personFormId, int personId, int formId, int questionId, List<int> choiceIds, List<FormQuestionChoice> choices, string userName)
        {
            return POD.Data.PATFormData.AddUpdatePersonFormQuestion(personFormId, personId, formId, questionId, choiceIds, choices, userName);
        }

        public static void SetCurrentSection(int personFormId, int personId, int formId, int currentSectionId, string userName)
        {
            POD.Data.PATFormData.SetCurrentSection(personFormId, personId, formId, currentSectionId, userName);
        }

        public static void CompleteForm(int personFormId, string userName, DateTime ? dateCompleted)
        {
            POD.Data.PATFormData.CompleteForm(personFormId, userName, dateCompleted);
        }

        public static List<PersonFormQuestionChoice> GetPersonQuestionChoices(int personFormId)
        {
            return POD.Data.PATFormData.GetPersonQuestionChoices(personFormId);
        }

        public static void MarkFormAsValidOrInvalid(int personFormId, string userName, bool isValid, bool isReportable)
        {
            POD.Data.PATFormData.MarkFormAsValidOrInvalid(personFormId, userName, isValid, isReportable);
        }

        
    }
}
