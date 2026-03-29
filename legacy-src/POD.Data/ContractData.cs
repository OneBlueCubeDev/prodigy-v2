using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using POD.Data.Entities;
using POD.Logging;

namespace POD.Data
{
    public static class ContractData
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
            using (var context = new PODContext())
            {
                try
                {
                    ContractEnrollmentQuota quota = context.ContractEnrollmentQuotas
                        .SingleOrDefault(x => x.ContractID == contractId && x.EnrollmentTypeID == enrollmentTypeId);

                    if (quota == null)
                    {
                        quota = context.ContractEnrollmentQuotas.CreateObject();
                        //quota.DateTimeStamp = DateTime.Now;
                        quota.ContractID = contractId;
                        quota.EnrollmentTypeID = enrollmentTypeId;
                        context.ContractEnrollmentQuotas.AddObject(quota);
                    }

                    //quota.LastModifiedBy = currentUserName;
                    quota.Amount = amount;
                    quota.ExpectedLengthInDays = expectedLengthInDays;
                    quota.RequiredProgrammingHours = requiredProgrammingHours;

                    context.SaveChanges();
                    return true;
                }
                catch (Exception ex)
                {
                    ex.Log();
                    return false;
                }
            }
        }

        /// <summary>
        /// Gets contract enrollment quotas by search parameters.
        /// </summary>
        /// <param name="contractId">The contract id.</param>
        /// <param name="enrollmentTypeId">The enrollment type id.</param>
        /// <returns></returns>
        public static List<ContractEnrollmentQuota> GetContractEnrollmentQuotaBySearch(int? contractId, int? enrollmentTypeId)
        {
            using (var context = new PODContext())
            {
                return context.ContractEnrollmentQuotas
                    .Include(x => x.Contract)
                    .Include(x => x.EnrollmentType)
                    .Where(x => (contractId == null || x.ContractID == contractId)
                                && (enrollmentTypeId == null || x.EnrollmentTypeID == enrollmentTypeId))
                    .ToList();
            }
        }

        /// <summary>
        /// Gets the contract enrollment quota by composite primary key.
        /// </summary>
        /// <param name="contractId">The contract id.</param>
        /// <param name="enrollmentTypeId">The enrollment type id.</param>
        /// <returns></returns>
        public static ContractEnrollmentQuota GetContractEnrollmentQuotaByKey(int contractId, int enrollmentTypeId)
        {
            using (var context = new PODContext())
            {
                return context.ContractEnrollmentQuotas
                    .Include(x => x.Contract)
                    .Include(x => x.EnrollmentType)
                    .SingleOrDefault(
                        x => x.ContractID == contractId
                             && x.EnrollmentTypeID == enrollmentTypeId);
            }
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
            using (var context = new PODContext())
            {
                try
                {
                    var quota = context.ContractEnrollmentQuotas
                        .SingleOrDefault(x => x.ContractID == contractId && x.EnrollmentTypeID == enrollmentTypeId);

                    if (quota != null)
                    {
                        context.ContractEnrollmentQuotas.DeleteObject(quota);
                        context.SaveChanges();
                        
                        message = "Success";
                        return true;
                    }
                }
                catch (Exception ee)
                {
                    ee.Log();
                    message = ee.Message;
                    return false;
                }

                message = string.Format("Contract Enrollment Quota not found for contract {0} and enrollment type {1}",
                                        contractId, enrollmentTypeId);
                return false;
            }
        }

        /// <summary>
        /// Adds or updates a contract not associated with a site or program
        /// </summary>
        /// <param name="key">The key.</param>
        /// <param name="status">The status.</param>
        /// <param name="contractNumber">The contract number.</param>
        /// <param name="start">The start.</param>
        /// <param name="end">The end.</param>
        /// <param name="currentUserName">Name of the current user.</param>
        /// <returns></returns>
        public static int AddUpdateContract(int key, int status, string contractNumber, DateTime? start, DateTime? end,
                                            string currentUserName)
        {
            return AddUpdateContract(key, status, contractNumber, start, end, null, null, currentUserName);
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
        /// <param name="currentUserName">Name of the current user.</param>
        /// <returns></returns>
        public static int AddUpdateContractForSite(int key, int status, string contractNumber, DateTime? start,
                                                   DateTime? end, int siteId, string currentUserName)
        {
            return AddUpdateContract(key, status, contractNumber, start, end, siteId, null, currentUserName);
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
        /// <param name="currentUserName">Name of the current user.</param>
        /// <returns></returns>
        public static int AddUpdateContractForProgram(int key, int status, string contractNumber, DateTime? start,
                                                      DateTime? end, int programId, string currentUserName)
        {
            return AddUpdateContract(key, status, contractNumber, start, end, null, programId, currentUserName);
        }

        private static int AddUpdateContract(int key, int status, string contractNumber, DateTime? start, DateTime? end,
                                             int? siteId, int? programId, string currentUserName)
        {
            using (var context = new PODContext())
            {
                try
                {
                    Contract contract = null;

                    Site site = siteId != null
                                    ? context.Locations.OfType<Site>()
                                          .SingleOrDefault(x => x.LocationID == siteId)
                                    : null;

                    Program program = programId != null
                                          ? context.Programs
                                                .SingleOrDefault(x => x.ProgramID == programId)
                                          : null;

                    if (key > 0)
                    {
                        contract = context.Contracts
                            .Include(x => x.Programs)
                            .Include(x => x.Sites)
                            .SingleOrDefault(x => x.ContractID == key);
                    }

                    if (contract == null)
                    {
                        contract = context.Contracts.CreateObject();
                        contract.DateTimeStamp = DateTime.Now;
                        context.Contracts.AddObject(contract);
                    }

                    if (site == null)
                    {
                        contract.Sites.Clear();
                    }
                    else
                    {
                        if (contract.Sites.Select(x => x.LocationID)
                                .Contains(siteId.Value) == false
                            || contract.Sites.Count > 1)
                        {
                            contract.Sites.Clear();
                            contract.Sites.Add(site);
                        }
                    }

                    if (program == null)
                    {
                        contract.Programs.Clear();
                    }
                    else
                    {
                        if (contract.Programs.Select(x => x.ProgramID)
                                .Contains(programId.Value) == false
                            || contract.Programs.Count > 1)
                        {
                            contract.Programs.Clear();
                            contract.Programs.Add(program);
                        }
                    }

                    contract.LastModifiedBy = currentUserName;
                    contract.StatusTypeID = status;
                    contract.ContractNumber = contractNumber;
                    contract.DateStart = start;
                    contract.DateEnd = end;

                    context.SaveChanges();
                    return contract.ContractID;
                }
                catch (Exception ex)
                {
                    ex.Log();
                    return 0;
                }
            }
        }

        /// <summary>
        /// Gets the contract by ID.
        /// </summary>
        /// <param name="key">The key.</param>
        /// <returns></returns>
        public static Contract GetContractByID(int key)
        {
            using (var context = new PODContext())
            {
                return context.Contracts
                    .Include(x => x.Programs)
                    .Include(x => x.Sites)
                    .SingleOrDefault(x => x.ContractID == key);
            }
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
        public static List<Contract> GetContractsBySearch(int? status, int? siteLocationId, int? programId, string contractNumber, DateTime? start, DateTime? end)
        {
            using (var context = new PODContext())
            {
                return context.Contracts
                    .Include(x => x.Programs)
                    .Include(x => x.Sites)
                    .Include(x => x.StatusType)
                    .Where(x => (status == null || x.StatusTypeID == status)
                                && (contractNumber == null || x.ContractNumber == contractNumber)
                                && (start == null || x.DateStart >= start)
                                && (end == null || x.DateEnd <= end)
                                && (siteLocationId == null || x.Sites.Any(s => s.SiteLocationID == siteLocationId))
                                && (programId == null || x.Programs.Any(p => p.ProgramID == programId)))
                    .ToList();
            }
        }

        /// <summary>
        /// Deletes the contract.
        /// </summary>
        /// <param name="key">The key.</param>
        /// <param name="message">The output message.</param>
        /// <returns></returns>
        public static bool DeleteContract(int key, out string message)
        {
            using (var context = new PODContext())
            {
                try
                {
                    var contract = context.Contracts
                        .SingleOrDefault(x => x.ContractID == key);

                    if (contract != null)
                    {
                        contract.Sites.Clear();
                        contract.Programs.Clear();
                        contract.ContractEnrollmentQuotas
                            .ToList().ForEach(context.DeleteObject);

                        context.Contracts.DeleteObject(contract);

                        context.SaveChanges();

                        message = "Success";
                        return true;
                    }
                }
                catch (Exception ee)
                {
                    ee.Log();
                    message = ee.Message;
                    return false;
                }

                message = string.Format("Contract with ID {0} not found", key);
                return false;
            }
        }
    }
}