export type Role = 'admin' | 'central' | 'site';

declare global {
  interface CustomJwtSessionClaims {
    metadata: {
      role?: Role;
      site_id?: string;
    };
  }
}
