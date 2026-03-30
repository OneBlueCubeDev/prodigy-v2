import pino from 'pino';

/**
 * Pino structured JSON logger singleton.
 * Outputs debug-level in development, info-level in production.
 * Never log sensitive data: SSN, passwords, auth tokens.
 */
const logger = pino({
  level: process.env.NODE_ENV === 'production' ? 'info' : 'debug',
});

export default logger;
