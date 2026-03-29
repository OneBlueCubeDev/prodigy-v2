using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Text;
using POD.Data.Entities;
using POD.Logging;
using System.Transactions;

namespace POD.Data
{
    public static class PATFormData
    {
        public static List<PersonForm> GetPersonForms(int personId)
        {
            using (PODContext context = new PODContext())
            {
                return context.PersonForms.Where(x => x.PersonId == personId).ToList();
            }
        }

        public static bool DoesInitialPATExist(int personId)
        {            

            using (PODContext context = new PODContext())
            {

                var result = false;

                var initPersonFormExist = context.PersonForms.Where(x => x.PersonId == personId && x.IsComplete && x.isInitialPAT == true);

                               if(initPersonFormExist.Any())
                {
                    result = true;
                }

                return result;
            }
        }

        public static bool DoesExitPATExist(int personId)
        {

            using (PODContext context = new PODContext())
            {

                var result = false;

                var initPersonFormExist = context.PersonForms.Where(x => x.PersonId == personId && x.IsComplete && x.isInitialPAT == false);

                if (initPersonFormExist.Any())
                {
                    result = true;
                }

                return result;
            }
        }

        public static List<FormSection> GetFormSections(int formId)
        {
            using (PODContext context = new PODContext())
            {
                return context.FormSections.Where(x => x.FormId == formId).ToList();
            }
        }

        public static bool IsFormQuestionChoiceClickAllChecked(int personFormId, int questionId, int choiceId)
        {
            using (PODContext context = new PODContext())
            {
                var result = false;
                //
                                
                    var choices = context.FormQuestionChoices.Where(x => x.QuestionId == questionId).OrderBy(x => x.ChoiceOrder).ToList();
                    var userChoices = context.PersonFormQuestionChoices.Where(x => x.FormQuestionChoice.QuestionId == questionId && x.PersonFormId == personFormId).ToList();

                    foreach (var c in choices)
                    {
                        if(c.ChoiceId == choiceId)
                        {
                            var userChoice = userChoices.FirstOrDefault(x => x.ChoiceId == c.ChoiceId);
                            if (userChoice != null)
                            {
                                c.IsChecked = true;
                                c.OtherText = userChoice.OtherText;

                            result = true;

                            }
                        }
                                                
                    }

                return result;
            }
        }

        public static PersonForm GetPersonForm(int personFormId)
        {
            using (PODContext context = new PODContext())
            {
                return context.PersonForms.FirstOrDefault(x => x.PersonFormId == personFormId);
            }
        }

        public static PersonForm GetExitPersonForm(int personFormId)
        {
            using (PODContext context = new PODContext())
            {
                return context.PersonForms.FirstOrDefault(x => x.PersonFormId == personFormId && x.IsComplete && x.isInitialPAT == true);

            }
        }

        public static PersonForm GetExitPersonFormByPersonid(int personId)
        {
            using (PODContext context = new PODContext())
            {
                return context.PersonForms.FirstOrDefault(x => x.PersonId == personId && x.IsComplete && x.isInitialPAT == false);

            }
        }

        public static void DeletePersonForm(int personFormId)
        {
            using (PODContext context = new PODContext())
            {
                try
                {

                    var pf = context.PersonForms.FirstOrDefault(x => x.PersonFormId == personFormId);

                    var choices = pf.PersonFormQuestionChoices.ToList();

                    foreach (var choice in choices)
                    {
                        pf.PersonFormQuestionChoices.Remove(choice);
                        context.DeleteObject(choice);
                    }

                    context.PersonForms.DeleteObject(pf);

                    context.SaveChanges();
                }
                catch (Exception ex)
                {
                    ex.Log();
                }
            }
        }



        public static List<FormQuestion> GetFormSectionQuestions(int sectionId)
        {
            using (PODContext context = new PODContext())
            {
                return context.FormQuestions.Where(x => x.SectionId == sectionId).Include("FormQuestionChoices").Include("FormQuestionType").ToList();
            }
        }

        public static List<FormQuestion> GetFormQuestions(int formId)
        {
            using (PODContext context = new PODContext())
            {
                return context.FormQuestions.Where(x => x.FormSection.FormId == formId).Include("FormQuestionChoices").Include("FormQuestionType").ToList();
            }
        }

        public static List<FormQuestionChoice> GetQuestionChoices(int personFormId, int questionId)
        {
            using (PODContext context = new PODContext())
            {
                var choices = context.FormQuestionChoices.Where(x => x.QuestionId == questionId).OrderBy(x=>x.ChoiceOrder).ToList();
                var userChoices = context.PersonFormQuestionChoices.Where(x => x.FormQuestionChoice.QuestionId == questionId && x.PersonFormId == personFormId).ToList();
                
                foreach (var c in choices)
                {
                    var userChoice = userChoices.FirstOrDefault(x => x.ChoiceId == c.ChoiceId);
                    if (userChoice != null)
                    {
                        c.IsChecked = true;
                        c.OtherText = userChoice.OtherText;

                    }
                }

                return choices;
            }
        }

       public static List<PersonFormQuestionChoice> GetPersonQuestionChoices(int personFormId)
        {
            using (PODContext context = new PODContext())
            {
                return context.PersonFormQuestionChoices.Where(x => x.PersonFormId == personFormId).Include("FormQuestionChoice").ToList();
            }
        }
        public static void SetCurrentSection(int personFormId, int personId, int formId, int currentSectionId, string userName)
        {
            using (PODContext context = new PODContext())
            {
                try
                {
                    var pf = context.PersonForms.FirstOrDefault(x => x.PersonFormId == personFormId );
                    if (pf == null)
                    {
                        pf = new PersonForm
                        {
                            CreateUserName = userName,
                            DateCreated = DateTime.Now,
                            FormId = formId,
                            PersonId = personId
                        };
                    }

                    pf.CurrentSectionId = currentSectionId;
                    pf.DateUpdated = DateTime.Now;
                    pf.UpdateUserName = userName;

                    if (pf.PersonFormId == 0)
                    {
                        context.PersonForms.AddObject(pf);
                    }
                    context.SaveChanges();

                }
                catch (Exception ex)
                {
                    ex.Log();
                }
            }
        }

        public static void CompleteForm(int personFormId, string userName, DateTime ? dateCompleted)
        {
            using (PODContext context = new PODContext())
            {
                try
                {
                    var pf = context.PersonForms.FirstOrDefault(x => x.PersonFormId == personFormId);
                    if (pf != null)
                    {
                        
                        pf.IsComplete = true;
                        pf.DateUpdated = DateTime.Now;
                        pf.UpdateUserName = userName;
                        pf.DateCompleted = dateCompleted;
                    }

                    context.SaveChanges();
                }
                catch (Exception ex)
                {
                    ex.Log();
                }
            }
        }

        public static void MarkFormAsValidOrInvalid(int personFormId, string userName, bool isValid, bool isReportable)
        {
            using (PODContext context = new PODContext())
            {
                try
                {
                    var pf = context.PersonForms.FirstOrDefault(x => x.PersonFormId == personFormId);
                    if (pf != null)
                    {
                        // only a valid form can be complete.                        
                        pf.IsValid = isValid;
                        pf.DateUpdated = DateTime.Now;
                        pf.UpdateUserName = userName;
                        pf.isReportable = isReportable;
                    }

                    context.SaveChanges();
                }
                catch (Exception ex)
                {
                    ex.Log();
                }
            }
        }

        public static PersonForm AddUpdatePersonForm(PersonForm f, string username)
        {
            PersonForm pf = null;

            using (PODContext context = new PODContext())
            {
                try
                {
                    pf = context.PersonForms.FirstOrDefault(x => x.PersonFormId == f.PersonFormId);
                    if (pf == null)
                    {
                        pf = new PersonForm
                            {
                                CreateUserName = username,
                                DateCreated = DateTime.Now,
                                FormId = f.FormId,
                                PersonId = f.PersonId
                            };
                    }

                    pf.IsValid = f.IsValid;
                    pf.IsComplete = f.IsComplete;
                    pf.CurrentSectionId = f.CurrentSectionId;
                    pf.DateUpdated = DateTime.Now;
                    pf.UpdateUserName = username;
                    pf.DateCompleted = f.DateCompleted;
                    pf.isInitialPAT = f.isInitialPAT;
                    pf.PATEnteredBy = f.PATEnteredBy;

                    if (pf.PersonFormId == 0)
                    {
                        context.PersonForms.AddObject(pf);
                    }
                    context.SaveChanges();

                }
                catch (Exception ex)
                {
                    ex.Log();
                }
            }

            return pf;
        }

        public static int AddUpdatePersonFormQuestion(int personFormId, int personId, int formId, int questionId, List<int> choiceIds, List<FormQuestionChoice> choicesAll, string userName)
        {
            using (PODContext context = new PODContext())
            {
                try
                {
                    var pf = context.PersonForms.FirstOrDefault(x => x.PersonFormId == personFormId);
                    if (pf == null)
                    {
                        pf = new PersonForm
                            {
                                PersonId = personId,
                                FormId = formId
                            };

                        pf = AddUpdatePersonForm(pf, userName);
                    }

                    var choices = context.PersonFormQuestionChoices.Where(x => x.PersonFormId == pf.PersonFormId && x.FormQuestionChoice.QuestionId == questionId).ToList();
                    
                    // first do some deletes
                    for (var x = choices.Count - 1; x >= 0; x--)
                    {
                        if (!choiceIds.Contains(choices[x].ChoiceId))
                        {
                            context.PersonFormQuestionChoices.DeleteObject(choices[x]);
                        }
                    }

                    foreach (int choiceId in choiceIds)
                    {
                        var choice = choices.FirstOrDefault(x => x.ChoiceId == choiceId);
                        if (choice == null)
                        {
                            choice = new PersonFormQuestionChoice
                                {
                                    ChoiceId = choiceId,
                                    CreateUserName = userName,
                                    DateCreated = DateTime.Now,
                                    PersonFormId = pf.PersonFormId
                                };
                        }

                        choice.DateUpdated = DateTime.Now;
                        choice.UpdateUserName = userName;

                        FormQuestionChoice fqc = choicesAll.Find( x => x.ChoiceId.Equals(choiceId));
                        if (fqc.IsOther)
                        {
                            choice.OtherText = fqc.OtherText;
                        }

                        if (choice.PersonFormQuestionChoiceId == 0)
                        {
                            context.PersonFormQuestionChoices.AddObject(choice);
                        }
                    }

                    context.SaveChanges();
                    return pf.PersonFormId;
                }
                catch (Exception ex)
                {
                    ex.Log();
                }

                return 0;
            }
        }

    }
}
