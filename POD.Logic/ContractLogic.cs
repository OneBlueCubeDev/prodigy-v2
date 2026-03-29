using System;
using System.Collections.Generic;
using POD.Data;
using POD.Data.Entities;

namespace POD.Logic
{
    public static class ContractLogic
    {
        /// <summary>
        /// Adds or updates a contract enrollment quota.
        /// </summary>
        /// <param name="contractId">The contract id.</param>
        /// <param name="enrollmentTypeId">The enrollment type id.</param>
        /// <param name="amount">The amount.</param>
        /// <param name="expectedLengthInDays">The expected length in days.</param>
        /// <param name="requiredProgrammingHours">The required programming hours.</param>
        /// <returns></returns>
        public static bool AddUpdateContractEnrollmentQuota(int contractId, int enrollmentTypeId, int amount,
                                                            int expectedLengthInDays, int requiredProgrammingHours)
        {
            return ContractData.AddUpdateContractEnrollmentQuota(contractId, enrollmentTypeId, amount,
                                                                 expectedLengthInDays, requiredProgrammingHours);
        }

        /// <summary>
        /// Gets contract enrollment quotas by search parameters.
        /// </summary>
        /// <param name="contractId">The contract id.</param>
        /// <param name="enrollmentTypeId">The enrollment type id.</param>
        /// <returns></returns>
        public static List<ContractEnrollmentQuota> GetContractEnrollmentQuotaBySearch(int? contractId = null,
                                                                                       int? enrollmentTypeId = null)
        {
            return ContractData.GetContractEnrollmentQuotaBySearch(contractId, enrollmentTypeId);
        }

        /// <summary>
        /// Gets the contract enrollment quota by composite primary key.
        /// </summary>
        /// <param name="contractId">The contract id.</param>
        /// <param name="enrollmentTypeId">The enrollment type id.</param>
        /// <returns></returns>
        public static ContractEnrollmentQuota GetContractEnrollmentQuotaByKey(int contractId, int enrollmentTypeId)
        {
            return ContractData.GetContractEnrollmentQuotaByKey(contractId, enrollmentTypeId);
        }

        /// <summary>
        /// Deletes the contract enrollment quota.
        /// </summary>
        /// <param name="contractId">The contract id.</param>
        /// <param name="enrollmentTypeId">The enrollment type id.</param>
        /// <param name="message">The output message</param>
        /// <returns></returns>
        public static bool DeleteContractEnrollmentQuota(int contractId, int enrollmentTypeId, out string message)
        {
            return ContractData.DeleteContractEnrollmentQuota(contractId, enrollmentTypeId, out message);
        }

        /// <summary>
        /// Adds or updates a contract not associated with a site or program
        /// </summary>
        /// <param name="key">The key.</param>
        /// <param name="status">The status.</param>
        /// <param name="contractNumber">The contract number.</param>
        /// <param name="start">The start.</param>
        /// <param name="end">The end.</param>
        /// <returns></returns>
        public static int AddUpdateContract(int key, int status, string contractNumber, DateTime? start, DateTime? end)
        {
            return ContractData.AddUpdateContract(key, status, contractNumber, start, end,
                                                  Security.GetCurrentUserProfile().UserName);
        }

        /// <summary>
        /// Adds or updates a site contract.
        /// </summary>
        /// <param name="key">The key.</param>
        /// <param name="status">The status.</param>
        /// <param name="contractNumber">The contract number.</param>
        /// <param name="start">The start.</param>
        /// <param name="end">The end.</param>
        /// <param name="siteId">The site id.</param>
        /// <returns></returns>
        public static int AddUpdateContractForSite(int key, int status, string contractNumber, DateTime? start,
                                                   DateTime? end, int siteId)
        {
            return ContractData.AddUpdateContractForSite(key, status, contractNumber, start, end, siteId,
                                                         Security.GetCurrentUserProfile().UserName);
        }

        /// <summary>
        /// Adds or updates a program contract.
        /// </summary>
        /// <param name="key">The key.</param>
        /// <param name="status">The status.</param>
        /// <param name="contractNumber">The contract number.</param>
        /// <param name="start">The start.</param>
        /// <param name="end">The end.</param>
        /// <param name="programId">The program id.</param>
        /// <returns></returns>
        public static int AddUpdateContractForProgram(int key, int status, string contractNumber, DateTime? start,
                                                      DateTime? end, int programId)
        {
            return ContractData.AddUpdateContractForProgram(key, status, contractNumber, start, end, programId,
                                                            Security.GetCurrentUserProfile().UserName);
        }

        /// <summary>
        /// Gets the contract by ID.
        /// </summary>
        /// <param name="key">The key.</param>
        /// <returns></returns>
        public static Contract GetContractByID(int key)
        {
            return ContractData.GetContractByID(key);
        }

        /// <summary>
        /// Gets the contracts by search parameters.
        /// </summary>
        /// <param name="status">The status.</param>
        /// <param name="programId">The Program ID </param>
        /// <param name="contractNumber">The contract number.</param>
        /// <param name="start">The start.</param>
        /// <param name="end">The end.</param>
        /// <param name="siteLocationId">The Site Location ID </param>
        /// <returns></returns>
        public static List<Contract> GetContractsBySearch(int? status = null, int? siteLocationId = null, int? programId = null,
            string contractNumber = null, DateTime? start = null, DateTime? end = null)
        {
            return ContractData.GetContractsBySearch(status, siteLocationId, programId, contractNumber, start, end);
        }

        /// <summary>
        /// Deletes the contract.
        /// </summary>
        /// <param name="key">The key.</param>
        /// <param name="message">The output message.</param>
        /// <returns></returns>
        public static bool DeleteContract(int key, out string message)
        {
            return ContractData.DeleteContract(key, out message);
        }
    }
}