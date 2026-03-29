using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using POD.Data.Entities;

namespace POD.Data.Entities
{
    public partial class Person
    {
        public string RelationshipTypeName
        {
            get;
            set;
        }
        public PhoneNumber WorkPhone
        {
            get
            {
                if (this.PhoneNumbers != null && this.PhoneNumbers.Count > 0)
                {
                    return this.PhoneNumbers.FirstOrDefault(p => p.PhoneNumberType.Name.ToLower().Contains("work"));
                }
                else
                {
                    return null;
                }

            }

        }
                public PhoneNumber CellPhone
        {
            get
            {
                if (this.PhoneNumbers != null && this.PhoneNumbers.Count > 0)
                {
                    return this.PhoneNumbers.FirstOrDefault(p => p.PhoneNumberType.Name.ToLower().Contains("cell"));
                }
                else
                {
                    return null;
                }

            }
        }
        public PhoneNumber HomePhone
        {
            get
            {
                if (this.PhoneNumbers != null && this.PhoneNumbers.Count > 0)
                {
                    return this.PhoneNumbers.FirstOrDefault(p => p.PhoneNumberType.Name.ToLower().Contains("home"));
                }
                else
                {
                    return null;
                }

            }

        }
        public Address MailingAddress
        {
            get
            {
                if (this.Addresses != null && this.Addresses.Count > 0)
                {
                    return this.Addresses.FirstOrDefault(p => p.AddressType.Name.ToLower().Contains("mailing"));
                }
                else
                {
                    return null;
                }

            }

        }
        public int? Age
        {
            get
            {
                if (this.DateOfBirth.HasValue)
                {
                    DateTime now = DateTime.Now;
                    int age = now.Year - this.DateOfBirth.Value.Year;
                    if (now.Month < this.DateOfBirth.Value.Month || (now.Month == this.DateOfBirth.Value.Month && now.Day < this.DateOfBirth.Value.Day))
                        age--;
                    return age;
                }
                else
                {
                    return null;
                }

            }
        }
        public string IsER
        {
            get;
            set;
        }
        public string FullName
        {
            get { return string.Format("{0} {1}", this.FirstName, this.LastName); }
        }

        public string RelationshipOther { get; set; }
    }
}
