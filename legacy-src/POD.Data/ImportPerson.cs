using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using POD.Data.Entities;

namespace POD.Data
{
    public class ImportPerson
    {
        public int ID { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string MiddleName { get; set; }
        public string DateOfBirth { get; set; }
        public string MatchedFirstName { get; set; }
        public string MatchedLastName { get; set; }
        public string MatchedMiddleName { get; set; }
        public string MatchedDateOfBirth { get; set; }
        public string Category { get; set; }
        public string RaceEntry { get; set; }
        public string GenderEntry { get; set; }

        public int PersonID { get; set; }
        public string DJJNumber { get; set; }
        public string SiteName { get; set; }
        public string StartDate { get; set; }
        public string EndDate { get; set; }
        public string CircuitID { get; set; }
        public string Suffix { get; set; }
        public string ErrorMessage { get; set; }
        public List<Person> PossibleMatchList { get; set; }
        public ImportPerson()
        { }

        public ImportPerson(string first, string last, string middle, string dob, int id, string djj, string suffix, string start, string enddate, string category, string gender, string race, string site, string circuit, string error)
        {
            FirstName = first;
            Suffix = suffix;
            LastName = last;
            MiddleName = middle;
            DateOfBirth = dob;
            ID = id;
            DJJNumber = djj;
            SiteName = site;
            StartDate = start;
            EndDate = enddate;
            RaceEntry = race;
            GenderEntry = gender;
            Category = category;
            CircuitID = circuit;
            ErrorMessage = error;
        }
        public ImportPerson(string first, string last, string middle, string circuit, int id, string djj, string suffix, string category)
        {
            FirstName = first;
            Suffix = suffix;
            LastName = last;
            MiddleName = middle;
            ID = id;
            Category = category;
            CircuitID = circuit;
            DJJNumber = djj;
            ErrorMessage = string.Empty;
            PossibleMatchList = new List<Person>();

        }

        public ImportPerson(string first, string last, string middle, string dob, int id, string djj, string site, string start, string enddate, string gender, string race, string category)
        {
            FirstName = first;
            LastName = last;
            MiddleName = middle;
            DateOfBirth = dob;
            ID = id;
            GenderEntry = gender;
            RaceEntry = race;
            Category = category;
            EndDate = enddate;
            DJJNumber = djj;
            SiteName = site;
            StartDate = start;
            ErrorMessage = string.Empty;
            PossibleMatchList = new List<Person>();
        }

    }
}
