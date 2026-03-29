using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using POD.Data.Entities;

namespace POD.Logic
{
    public static class AddressPhoneNumerLogic
    {
        #region Address

        /// <summary>
        /// get address by id
        /// </summary>
        /// <param name="addressid"></param>
        /// <returns></returns>
        public static Address GetAddressByID(int addressid)
        {
            return POD.Data.AddressPhoneData.GetAddressByID(addressid);
        }

        /// <summary>
        /// get address by id and type
        /// </summary>
        /// <param name="personid">person identifier</param>
        /// <param name="typekey">AddressType Identifier</param>
        /// <returns></returns>
        public static Address GetAddressByTypeAndPersonID(int typekey, int personid)
        {
            return POD.Data.AddressPhoneData.GetAddressByTypeAndPersonID(typekey, personid);
        }

         /// <summary>
        /// get school address by person
        /// </summary>
        /// <param name="personID">person identifier</param>
        /// <returns></returns>
        public static Address GetSchoolAddressPersonID(int personID)
        {
            return POD.Data.AddressPhoneData.GetSchoolAddressPersonID(personID);
        }
        /// <summary>
        /// add update address
        /// </summary>
        /// <returns></returns>
        public static int AddUpdateAddress(int? addressid, int personid, string street, string street1, string aptnum, string city, string state, string zip, int? countyid, int addressTypeid, int statusType)
        {
            return POD.Data.AddressPhoneData.AddUpdateAddress(addressid, personid, street, street1, aptnum, city, state, zip, countyid, addressTypeid, statusType);
        }
        /// <summary>
        /// add update address
        /// </summary>
        /// <param name="personID">address identifier</param>
        /// <param name="typekey">AddressType Identifier</param>
        /// <returns></returns>
        public static int AddUpdateAddress(int? addressid, string street, string street1, string aptnum, string city, string state, string zip, int? countyid, int addressTypeid, int statusType)
        {
            return POD.Data.AddressPhoneData.AddUpdateAddress(addressid, street, street1, aptnum, city, state, zip, countyid, addressTypeid, statusType);
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
            return POD.Data.AddressPhoneData.GetPhoneNumberByID(numKey);
        }

        /// <summary>
        /// get PhoneNumber by id and type
        /// </summary>
        /// <param name="personid">PhoneNumber identifier</param>
        /// <param name="typekey">PhoneNumber Type Identifier</param>
        /// <returns></returns>
        public static PhoneNumber GetPhoneNumberByTypeAndPersonID(int typekey, int personid)
        {
            return POD.Data.AddressPhoneData.GetPhoneNumberByTypeAndPersonID(typekey, personid);
        }

        /// <summary>
        /// get PhoneNumbers by loc id
        /// </summary>
        /// <param name="addressid"></param>
        /// <returns></returns>
        public static List<PhoneNumber> GetPhoneNumbersByLocationID(int locid)
        {
            return POD.Data.AddressPhoneData.GetPhoneNumbersByLocationID(locid);

        }

        /// <summary>
        /// add update phonenumber
        /// </summary>
        /// <returns></returns>
        public static int AddUpdatePhoneNumber(int id, int personid, string number, int Typeid)
        {
            return POD.Data.AddressPhoneData.AddUpdatePhoneNumber(id, personid, number, Typeid);
        }
        /// <summary>
        /// add update number
        /// </summary>
        /// <param name="personID">phone num identifier</param>
        /// <param name="typekey">Identifier</param>
        /// <returns></returns>
        public static int AddUpdatePhoneNumber(int id, string number, int typeid)
        {
            return POD.Data.AddressPhoneData.AddUpdatePhoneNumber(id, number, typeid);
        }
        #endregion
    }
}
