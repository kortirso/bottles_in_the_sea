import type { KeyValue } from 'entities';

const DEFAULT_LOCALE = 'en';

export const currentLocale =
  (document.getElementById('current_locale') as HTMLInputElement).value || DEFAULT_LOCALE;

export const localizeValue = (value?: KeyValue) => {
  if (!value) return '';

  return value[currentLocale] || value[DEFAULT_LOCALE];
};

export const localizeRoute = (value: string) => {
  if (currentLocale === DEFAULT_LOCALE) return value;

  return `/${currentLocale}${value}`;
};
