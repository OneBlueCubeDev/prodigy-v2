using System;
using System.Collections.Generic;

namespace POD.Logic.Reporting.Support
{
    public class GenericEqualityComparer<T> : IEqualityComparer<T>
    {
        private readonly Func<T, T, bool> _eqFn;
        private readonly Func<T, int> _hashFn;

        public GenericEqualityComparer(Func<T, T, bool> eqFn, Func<T, int> hashFn)
        {
            _eqFn = eqFn;
            _hashFn = hashFn;
        }

        #region IEqualityComparer<T> Members

        public bool Equals(T x, T y)
        {
            return _eqFn != null
                       ? _eqFn(x, y)
                       : x.Equals(y);
        }

        public int GetHashCode(T obj)
        {
            return _hashFn != null
                       ? _hashFn(obj)
                       : obj.GetHashCode();
        }

        #endregion
    }
}