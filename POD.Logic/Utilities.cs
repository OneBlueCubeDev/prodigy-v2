using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.Entity;
using POD.Data.Entities;
using System.IO;
using System.Net.Mail;
using POD.Logging;

namespace POD.Logic
{
    public static class Utilities
    {
        /// <summary>
        /// all values are set to negative one
        /// </summary>
        /// <returns></returns>
        public static Dictionary<string, string> SetDefaultSearchFilters(string type)
        {
            Dictionary<string, string> list = new Dictionary<string, string>();

            switch (type)
            {
                case "Enrollment":
                    list.Add("Name", "-1");
                    list.Add("Guardian", "-1");
                    list.Add("Zip", "-1");
                    list.Add("School", "-1");
                    list.Add("Type", "-1");
                    list.Add("Status", "2");
                    list.Add("Year", "27");
                    list.Add("RegStartDate", "-1");
                    list.Add("RegEndDate", "-1");
                    list.Add("DJJ", "-1");
                    list.Add("Race", "-1");
                    list.Add("youthtype", "1");
                    break;
                case "Attendance":
                    list.Add("Name", "-1");
                    list.Add("Site", "-1");
                    list.Add("Loc", "-1");
                    list.Add("Class", "-1");
                    list.Add("Event", "-1");
                    list.Add("RegStartDate", "-1");
                    list.Add("RegEndDate", "-1");
                    break;
                case "Class":
                    list.Add("Name", "-1");
                    list.Add("Program", "-1");
                    list.Add("Loc", "-1");
                    list.Add("Instructor", "-1");
                    list.Add("Assistant", "-1");
                    list.Add("RegStartDate", "-1");
                    list.Add("RegStartDate2", "-1");
                    list.Add("RegEndDate", "-1");
                    list.Add("RegEndDate2", "-1");
                    break;
                case "Event":
                    list.Add("Name", "-1");
                    list.Add("Type", "-1");
                    list.Add("Loc", "-1");
                    list.Add("Status", "-1");
                    list.Add("RegStartDate", "-1");
                    list.Add("RegStartDate2", "-1");
                    list.Add("RegEndDate", "-1");
                    list.Add("RegEndDate2", "-1");
                    break;
                case "Inventory":
                    list.Add("Name", "-1");
                    list.Add("Type", "-1");
                    list.Add("Loc", "-1");
                    list.Add("Man", "-1");
                    list.Add("Serial", "-1");
                    list.Add("Org", "-1");
                    list.Add("Tag", "-1");
                    list.Add("DJJTag", "-1");
                    break;
                case "LessonPlan":
                    list.Add("Name", "-1");
                    list.Add("Loc", "-1");
                    list.Add("Instructor", "-1");
                    list.Add("Assistant", "-1");
                    list.Add("RegStartDate", "-1");
                    list.Add("RegStartDate2", "-1");
                    list.Add("RegEndDate", "-1");
                    list.Add("RegEndDate2", "-1");
                    list.Add("AgeGroup", "-1");
                    list.Add("LessonPlanStatus", "-1");
                    break;

            }
            return list;
        }

        /// <summary>
        /// takes dictionary and returns string concatenation
        /// for querystring passing of values
        /// </summary>
        /// <param name="filterList">keyword search parameters</param>
        /// <returns>string</returns>
        public static string SetSearchFilter(Dictionary<string, string> filterList)
        {
            string searchFilter = string.Empty;

            try
            {
                foreach (KeyValuePair<string, string> pair in filterList)
                {
                    searchFilter += string.Format("{0},", pair.Value.ToLower());

                }
            }
            catch (Exception ex)
            {
                ex.Log();
            }

            return searchFilter.TrimEnd(',');
        }

        public static Dictionary<string, string> GetSearchFilters(string filter, string type)
        {
            Dictionary<string, string> searchFilter = new Dictionary<string, string>();
            string[] querystringFilter = filter.Split(',');
            try
            {
                switch (type)
                {
                    case "Enrollment":
                        searchFilter.Add("Name", querystringFilter[0]);
                        searchFilter.Add("Guardian", querystringFilter[1]);
                        searchFilter.Add("Zip", querystringFilter[2]);
                        searchFilter.Add("School", querystringFilter[3]);
                        searchFilter.Add("Type", querystringFilter[4]);
                        searchFilter.Add("Status", querystringFilter[5]);
                        searchFilter.Add("Year", querystringFilter[6]);
                        searchFilter.Add("RegStartDate", querystringFilter[7]);
                        searchFilter.Add("RegEndDate", querystringFilter[8]);
                        searchFilter.Add("DJJ", querystringFilter[9]);
                        searchFilter.Add("Race", querystringFilter[10]);
                        searchFilter.Add("youthtype", querystringFilter[11]);
                        break;
                    case "Attendance":
                        searchFilter.Add("Name", querystringFilter[0]);
                        searchFilter.Add("Site", querystringFilter[1]);
                        searchFilter.Add("Loc", querystringFilter[2]);
                        searchFilter.Add("Class", querystringFilter[3]);
                        searchFilter.Add("Event", querystringFilter[4]);
                        searchFilter.Add("RegStartDate", querystringFilter[5]);
                        searchFilter.Add("RegEndDate", querystringFilter[6]);
                        break;
                    case "Class":
                        searchFilter.Add("Name", querystringFilter[0]);
                        searchFilter.Add("Program", querystringFilter[1]);
                        searchFilter.Add("Loc", querystringFilter[2]);
                        searchFilter.Add("Instructor", querystringFilter[3]);
                        searchFilter.Add("Assistant", querystringFilter[4]);
                        searchFilter.Add("RegStartDate", querystringFilter[5]);
                        searchFilter.Add("RegStartDate2", querystringFilter[6]);
                        searchFilter.Add("RegEndDate", querystringFilter[7]);
                        searchFilter.Add("RegEndDate2", querystringFilter[8]);
                        break;
                    case "Event":
                        searchFilter.Add("Name", querystringFilter[0]);
                        searchFilter.Add("Type", querystringFilter[1]);
                        searchFilter.Add("Loc", querystringFilter[2]);
                        searchFilter.Add("Status", querystringFilter[3]);
                        searchFilter.Add("RegStartDate", querystringFilter[4]);
                        searchFilter.Add("RegStartDate2", querystringFilter[5]);
                        searchFilter.Add("RegEndDate", querystringFilter[6]);
                        searchFilter.Add("RegEndDate2", querystringFilter[7]);
                        break;
                    case "Inventory":
                        searchFilter.Add("Name", querystringFilter[0]);
                        searchFilter.Add("Type", querystringFilter[1]);
                        searchFilter.Add("Loc", querystringFilter[2]);
                        searchFilter.Add("Man", querystringFilter[3]);
                        searchFilter.Add("Serial", querystringFilter[4]);
                        searchFilter.Add("Org", querystringFilter[5]);
                        searchFilter.Add("Tag", querystringFilter[6]);
                        searchFilter.Add("DJJTag", querystringFilter[7]);
                        break;
                    case "LessonPlan":
                        searchFilter.Add("Name", querystringFilter[0]);
                        searchFilter.Add("Loc", querystringFilter[1]);
                        searchFilter.Add("Instructor", querystringFilter[2]);
                        searchFilter.Add("Assistant", querystringFilter[3]);
                        searchFilter.Add("RegStartDate", querystringFilter[4]);
                        searchFilter.Add("RegStartDate2", querystringFilter[5]);
                        searchFilter.Add("RegEndDate", querystringFilter[6]);
                        searchFilter.Add("RegEndDate2", querystringFilter[7]);
                        searchFilter.Add("AgeGroup", querystringFilter[8]);
                        searchFilter.Add("LessonPlanStatus", querystringFilter[9]);
                        break;
                }

            }
            catch (Exception ex)
            {
                ex.Log();
            }

            return searchFilter;
        }

        public static T GetValueFromAnonymousType<T>(object dataitem, string itemkey)
        {
            System.Type type = dataitem.GetType();
            try
            {
                T itemvalue = (T)type.GetProperty(itemkey).GetValue(dataitem, null);
                return itemvalue;
            }
            catch (Exception ex)
            {
                ex.Log();
                T itemvalue = default(T);
                return itemvalue;
            }
        }

        public static bool IsReleaseDateOnWeekend(DateTime relDate)
        {
            var result = false;
            

            //check to see that the day fo the week is not on saturday or sunday
            if (relDate.DayOfWeek == DayOfWeek.Saturday || relDate.DayOfWeek == DayOfWeek.Sunday)
            {
                result = true;
            }
            
            return result;
        }

        public static bool IsFederalHoliday(this DateTime date)
        {
            // to ease typing
            int nthWeekDay = (int)(Math.Ceiling((double)date.Day / 7.0d));
            DayOfWeek dayName = date.DayOfWeek;
            bool isThursday = dayName == DayOfWeek.Thursday;
            bool isFriday = dayName == DayOfWeek.Friday;
            bool isMonday = dayName == DayOfWeek.Monday;
            bool isWeekend = dayName == DayOfWeek.Saturday || dayName == DayOfWeek.Sunday;

            // New Years Day (Jan 1, or preceding Friday/following Monday if weekend)
            if ((date.Month == 12 && date.Day == 31 && isFriday) ||
                (date.Month == 1 && date.Day == 1 && !isWeekend) ||
                (date.Month == 1 && date.Day == 2 && isMonday)) return true;

            // MLK day (3rd monday in January)
            if (date.Month == 1 && isMonday && nthWeekDay == 3) return true;

            // President’s Day (3rd Monday in February)
            if (date.Month == 2 && isMonday && nthWeekDay == 3) return true;

            // Memorial Day (Last Monday in May)
            if (date.Month == 5 && isMonday && date.AddDays(7).Month == 6) return true;

            // Independence Day (July 4, or preceding Friday/following Monday if weekend)
            if ((date.Month == 7 && date.Day == 3 && isFriday) ||
                (date.Month == 7 && date.Day == 4 && !isWeekend) ||
                (date.Month == 7 && date.Day == 5 && isMonday)) return true;

            // Labor Day (1st Monday in September)
            if (date.Month == 9 && isMonday && nthWeekDay == 1) return true;

            // Columbus Day (2nd Monday in October)
            if (date.Month == 10 && isMonday && nthWeekDay == 2) return true;

            // Veteran’s Day (November 11, or preceding Friday/following Monday if weekend))
            if ((date.Month == 11 && date.Day == 10 && isFriday) ||
                (date.Month == 11 && date.Day == 11 && !isWeekend) ||
                (date.Month == 11 && date.Day == 12 && isMonday)) return true;

            // Thanksgiving Day (4th Thursday in November)
            if (date.Month == 11 && isThursday && nthWeekDay == 4) return true;

            // Christmas Day (December 25, or preceding Friday/following Monday if weekend))
            if ((date.Month == 12 && date.Day == 24 && isFriday) ||
                (date.Month == 12 && date.Day == 25 && !isWeekend) ||
                (date.Month == 12 && date.Day == 26 && isMonday)) return true;

            return false;
        }

        public static int GetAge(DateTime birthDate, DateTime? dateApplied)
        {
            DateTime now;
            if (dateApplied.HasValue)
            {
                now = dateApplied.Value;
            }
            else
            {
                now = DateTime.Now;
            }

            int age = now.Year - birthDate.Year;
            if (now.Month < birthDate.Month || (now.Month == birthDate.Month && now.Day < birthDate.Day))
                age--;
            return age;
        }

        /// <summary>
        /// sends mail
        /// option to specifiy outer template
        /// other wise default is applied
        /// </summary>
        /// <param name="emailTo"></param>
        /// <param name="emailFrom"></param>
        /// <param name="subject"></param>
        /// <param name="replyTo"></param>
        /// <param name="body"></param>
        /// <param name="outerTemplate"></param>
        public static void SendMail(string emailTo, string emailFrom, string subject, string replyTo, string body, string outerTemplate, string partialFilePath)
        {
            if (!string.IsNullOrEmpty(emailTo))
            {
                // set Email body
                string mailBody = string.Empty;

                // get template
                string FilePath = partialFilePath;
                if (string.IsNullOrEmpty(outerTemplate))
                {
                    FilePath += "Template_GeneralBranding.htm";
                }

                if (System.IO.File.Exists(FilePath))
                {
                    FileStream f1 = new FileStream(FilePath, FileMode.Open);
                    StreamReader sr = new StreamReader(f1);
                    mailBody = sr.ReadToEnd();
                    mailBody = mailBody.Replace("{EmailContent}", body.Trim());

                    f1.Close();
                }
                else
                {
                    mailBody = body;
                }

                // create message
                MailMessage mail = new MailMessage();

                string[] emailsTo = emailTo.Split(',');
                foreach (string email in emailsTo)
                {
                    mail.To.Add(new MailAddress(email));
                }

                string[] emailsFrom = emailFrom.Split(',');
                mail.From = new MailAddress(emailsFrom.First());

                string[] emailsReplyTo = replyTo.Split(',');
                foreach (string s in emailsReplyTo)
                {
                    mail.ReplyToList.Add(new MailAddress(s));
                }

                mail.Subject = subject;
                mail.Body = mailBody;
                mail.IsBodyHtml = true;

                // send message
                SmtpClient smtp = new SmtpClient();
                smtp.Send(mail);
            }
        }

    }//class

}//namespace
