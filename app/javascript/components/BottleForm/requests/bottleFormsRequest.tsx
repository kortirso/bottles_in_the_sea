import { apiRequest } from 'requests/helpers/apiRequest';

export const bottleFormsRequest = async (worldUuid: string) => {
  const result = await apiRequest({
    url: `/worlds/${worldUuid}/bottle_forms.json`,
  });
  return result.bottle_forms;
};
