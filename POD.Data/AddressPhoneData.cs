using System;
using System.Collections.Generic;
using System.Linq;
using System.Data.Entity;
using POD.Data.Entities;
using POD.Logging;

namespace POD.Data
{
    public static class AddressPhoneData
    {
        #region Address

        /// <summary>
        /// get address by id
        /// </summary>
        /// <param name="addressid"></param>
        /// <returns></returns>
        public static Address GetAddressByID(int addressid)
        {
            using (PODContext context = new PODContext())
            {
                return context.Addresses.Include(x => x.AddressType).FirstOrDefault(a => a.AddressID == addressid);
            }
        }

        /// <summary>
        /// get address by id and type
        /// </summary>
        /// <param name="personID">person identifier</param>
        /// <param name="typekey">AddressType Identifier</param>
        /// <returns></returns>
        public static Address GetAddressByTypeAndPersonID(int typekey, int personID)
        {
            using (PODContext context = new PODContext())
            {
                return context.Addresses.Include(x => x.AddressType).FirstOrDefault(a => a.AddressType.AddressTypeID == typekey && a.Persons.Any(p => p.PersonID == personID));
            }
        }

        /// <summary>
        /// get school address by person
        /// </summary>
        /// <param name="personID">person identifier</param>
        /// <returns></returns>
        public static Address GetSchoolAddressPersonID(int personID)
        {
            using (PODContext context = new PODContext())
            {
                return context.Addresses.Include(x => x.AddressType).FirstOrDefault(a => a.Students.Any(p=> p.PersonID == personID));
            }
        }

        /// <summary>
        /// add update address
        /// </summary>
        /// <param name="personID">address identifier</param>
        /// <param name="typekey">AddressType Identifier</param>
        /// <returns></returns>
        public static int AddUpdateAddress(int? addressid, int personid, string street, string street1, string aptnum, string city, string state, string zip, int? countyid, int addressTypeid, int statusType)
        {
            int newAddressid = 0;
            bool isAdd = false;
            using (PODContext context = new PODContext())
            {
                try
                {
                    Address origAddress = null;
                    AddressType type = context.AddressTypes.FirstOrDefault(t => t.AddressTypeID == addressTypeid);
                    StatusType stType = context.StatusTypes.FirstOrDefault(tt => tt.StatusTypeID == statusType);

                    if (addressid.HasValue)
                    {
                        origAddress = context.Addresses.FirstOrDefault(a => a.AddressID == addressid);
                        //set to null if other person has this address too and we are changing the essentials of this address
                        //street apt # city zip state
                        if (origAddress.Persons.Any(p => p.PersonID != personid) && (
                            (!string.IsNullOrEmpty(origAddress.AddressLine1) && origAddress.AddressLine1.ToLower() != street.ToLower()) ||
                            (!string.IsNullOrEmpty(origAddress.AddressLine2) && origAddress.AddressLine2.ToLower() != street1.ToLower()) ||
                            (!string.IsNullOrEmpty(origAddress.Zip) && origAddress.Zip.ToLower() != zip.ToLower()) ||
                            (!string.IsNullOrEmpty(origAddress.AptNum) && origAddress.AptNum.ToLower() != aptnum.ToLower()) ||
                            (!string.IsNullOrEmpty(origAddress.City) && origAddress.City.ToLower() != city.ToLower()) ||
                            (!string.IsNullOrEmpty(origAddress.State) && origAddress.State.ToLower() != state.ToLower())))
                        {
                            origAddress = null;
                        }
                    }
                    else
                    {
                        //try finding a match on address properties
                        origAddress = context.Addresses.FirstOrDefault(a => a.AddressLine1.ToLower() == street.ToLower() && a.AddressLine2.ToLower() == street1.ToLower() &&
                                                                               a.City.ToLower() == city.ToLower() && a.Zip.ToLower() == zip.ToLower()
                                                                               && a.AptNum.ToLower() == aptnum.ToLower());



                    }

                    if (origAddress == null)
                    {
                        origAddress = new Address();
                        origAddress.DateTimeStamp = DateTime.Now;
                        origAddress.rowguid = Guid.NewGuid();
                        isAdd = true;
                    }
                    origAddress.AddressLine1 = street;
                    origAddress.AddressLine2 = street1;
                    origAddress.AptNum = aptnum;
                    origAddress.State = state;
                    origAddress.CountyID = countyid;
                    origAddress.City = city;
                    origAddress.Zip = zip;
                    origAddress.AddressType = type;
                    origAddress.StatusType = stType;

                    if (isAdd)
                    {
                        context.Addresses.AddObject(origAddress);
                    }
                    context.SaveChanges();
                    newAddressid = origAddress.AddressID;
                }

                catch (Exception ex)
                {
                    ex.Log();
                }
                return newAddressid;
            }
        }

        /// <summary>
        /// add update address
        /// </summary>
        /// <param name="personID">address identifier</param>
        /// <param name="typekey">AddressType Identifier</param>
        /// <returns></returns>
        public static int AddUpdateAddress(int? addressid, string street, string street1, string aptnum, string city, string state, string zip, int? countyid, int addressTypeid, int statusType)
        {
            int newAddressid = 0;
            bool isAdd = false;
            using (PODContext context = new PODContext())
            {
                try
                {
                    Address origAddress = null;
                    AddressType type = context.AddressTypes.FirstOrDefault(t => t.AddressTypeID == addressTypeid);
                    StatusType stType = context.StatusTypes.FirstOrDefault(tt => tt.StatusTypeID == statusType);

                    if (addressid.HasValue)
                    {
                        origAddress = context.Addresses.FirstOrDefault(a => a.AddressID == addressid);
                        //set to null if other person has this address too and we are changing the essentials of this address
                        //street apt # city zip state
                        if (origAddress.Persons.Any() && (
                            (!string.IsNullOrEmpty(origAddress.AddressLine1) && origAddress.AddressLine1.ToLower() != street.ToLower()) ||
                            (!string.IsNullOrEmpty(origAddress.AddressLine2) && origAddress.AddressLine2.ToLower() != street1.ToLower()) ||
                            (!string.IsNullOrEmpty(origAddress.Zip) && origAddress.Zip.ToLower() != zip.ToLower()) ||
                            (!string.IsNullOrEmpty(origAddress.AptNum) && origAddress.AptNum.ToLower() != aptnum.ToLower()) ||
                            (!string.IsNullOrEmpty(origAddress.City) && origAddress.City.ToLower() != city.ToLower()) ||
                            (!string.IsNullOrEmpty(origAddress.State) && origAddress.State.ToLower() != state.ToLower())))
                        {
                            origAddress = null;
                        }
                    }
                    else
                    {
                        //try finding a match on address properties
                        origAddress = context.Addresses.FirstOrDefault(a => a.AddressLine1.ToLower() == street.ToLower() && a.AddressLine2.ToLower() == street1.ToLower() &&
                                                                               a.City.ToLower() == city.ToLower() && a.Zip.ToLower() == zip.ToLower()
                                                                               && a.AptNum.ToLower() == aptnum.ToLower());


                    }

                    if (origAddress == null)
                    {
                        origAddress = new Address();
                        origAddress.DateTimeStamp = DateTime.Now;
                        origAddress.rowguid = Guid.NewGuid();
                        isAdd = true;
                    }
                    origAddress.AddressLine1 = street;
                    origAddress.AddressLine2 = street1;
                    origAddress.AptNum = aptnum;
                    origAddress.State = state;
                    origAddress.CountyID = countyid;
                    origAddress.City = city;
                    origAddress.Zip = zip;
                    origAddress.AddressType = type;
                    origAddress.StatusType = stType;

                    if (isAdd)
                    {
                        context.Addresses.AddObject(origAddress);
                    }
                    context.SaveChanges();
                    newAddressid = origAddress.AddressID;
                }

                catch (Exception ex)
                {
                    ex.Log();
                }
                return newAddressid;
            }
        }


        #endregion

        #region Phone Numbers
        /// <summary>
        /// get PhoneNumber by id
        /// </summary>
        /// <param name="addressid"></param>
        /// <returns></returns>
        public static PhoneNumber GetPhoneNumberByID(int numKey)
        {
            using (PODContext context = new PODContext())
            {
                return context.PhoneNumbers.Include(x => x.PhoneNumberType).FirstOrDefault(a => a.PhoneNumberID == numKey);
            }
        }

        /// <summary>
        /// get PhoneNumbers by loc id
        /// </summary>
        /// <param name="addressid"></param>
        /// <returns></returns>
        public static List<PhoneNumber> GetPhoneNumbersByLocationID(int locid)
        {
            using (PODContext context = new PODContext())
            {
                Location currentLocation = context.Locations.Include(x => x.PhoneNumbers.Select(p => p.PhoneNumberType)).FirstOrDefault(l => l.LocationID == locid);
                if (currentLocation != null && currentLocation.PhoneNumbers.Count > 0)
                {
                    return currentLocation.PhoneNumbers.ToList();
                }
                else
                {
                    return null;
                }
            }
        }

        /// <summary>
        /// get PhoneNumber by id and type
        /// </summary>
        /// <param name="personID">PhoneNumber identifier</param>
        /// <param name="typekey">PhoneNumber Type Identifier</param>
        /// <returns></returns>
        public static PhoneNumber GetPhoneNumberByTypeAndPersonID(int typekey, int personID)
        {
            using (PODContext context = new PODContext())
            {
                Person currentPerson = context.Persons.Include(x => x.PhoneNumbers.Select(p => p.PhoneNumberType)).FirstOrDefault(l => l.PersonID == personID);
                return currentPerson.PhoneNumbers.FirstOrDefault(a => a.PhoneNumberType.PhoneNumberTypeID == typekey);
            }
        }

        /// <summary>
        /// add update number
        /// </summary>
        /// <param name="personID">phone num identifier</param>
        /// <param name="typekey">Identifier</param>
        /// <returns></returns>
        public static int AddUpdatePhoneNumber(int id, int personid, string number, int typeid)
        {
            int newid = 0;
            bool isAdd = false;
            using (PODContext context = new PODContext())
            {
                try
                {
                    PhoneNumber origNumber = null;
                    PhoneNumberType type = context.PhoneNumberTypes.FirstOrDefault(t => t.PhoneNumberTypeID == typeid);
                    if (id != 0)
                    {
                        origNumber = context.PhoneNumbers.Include(x => x.Persons).FirstOrDefault(a => a.PhoneNumberID == id);
                        //if the same number is assigned to someone and we are changing the number, then add new one
                        //rather than editing
                        if (origNumber.Persons.Any(p => p.PersonID != personid) && number != origNumber.Phone)
                        {
                            origNumber = null;
                        }
                    }
                    else
                    {
                        //check against number match
                        origNumber = context.PhoneNumbers.FirstOrDefault(a => a.Phone == number);
                    }

                    if (origNumber == null)
                    {
                        origNumber = new PhoneNumber();
                        origNumber.DateTimeStamp = DateTime.Now;
                        origNumber.rowguid = Guid.NewGuid();
                        isAdd = true;
                    }
                    origNumber.Phone = number;
                    origNumber.PhoneNumberType = type;

                    if (isAdd)
                    {
                        context.PhoneNumbers.AddObject(origNumber);
                    }
                    context.SaveChanges();
                    newid = origNumber.PhoneNumberID;
                }

                catch (Exception ex)
                {
                    ex.Log();
                }
                return newid;
            }
        }

        /// <summary>
        /// add update number
        /// </summary>
        /// <param name="personID">phone num identifier</param>
        /// <param name="typekey">Identifier</param>
        /// <returns></returns>
        public static int AddUpdatePhoneNumber(int id, string number, int typeid)
        {
            int newid = 0;
            bool isAdd = false;
            using (PODContext context = new PODContext())
            {
                try
                {
                    PhoneNumber origNumber = null;
                    PhoneNumberType type = context.PhoneNumberTypes.FirstOrDefault(t => t.PhoneNumberTypeID == typeid);
                    if (id != 0)
                    {
                        origNumber = context.PhoneNumbers.Include(x => x.Persons).FirstOrDefault(a => a.PhoneNumberID == id);
                        //if the same number is assigned to someone and we are changing the number, then add new one
                        //rather than editing
                        if (origNumber.Persons.Any() && number != origNumber.Phone)
                        {
                            origNumber = null;
                        }
                    }
                    else
                    {
                        //check against number match
                        origNumber = context.PhoneNumbers.FirstOrDefault(a => a.Phone == number);
                    }

                    if (origNumber == null)
                    {
                        origNumber = new PhoneNumber();
                        origNumber.DateTimeStamp = DateTime.Now;
                        origNumber.rowguid = Guid.NewGuid();
                        isAdd = true;
                    }
                    origNumber.Phone = number;
                    origNumber.PhoneNumberType = type;

                    if (isAdd)
                    {
                        context.PhoneNumbers.AddObject(origNumber);
                    }
                    context.SaveChanges();
                    newid = origNumber.PhoneNumberID;
                }

                catch (Exception ex)
                {
                    ex.Log();
                }
                return newid;
            }
        }

        #endregion
    }
}
