import { Attribute } from 'entities';
import { apiRequest } from 'requests/helpers/apiRequest';

export const worldCellsRequest = async (worldUuid: string) => {
  const result = await apiRequest({
    url: `/cells?world_uuid=${worldUuid}`,
  });
  return result.cells.data.map((element: Attribute) => element.attributes);;
};
