import { csrfToken } from 'helpers';
import { apiRequest } from 'requests/helpers/apiRequest';

export const submitFormRequest = async (mapPoint, worldUuid: string) => {
  const searcherPayload = {
    name: 'Searcher'
  };

  const cellPayload = {
    column: mapPoint.column,
    row: mapPoint.row
  };

  const requestOptions = {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'X-CSRF-TOKEN': csrfToken(),
    },
    body: JSON.stringify({ searcher: searcherPayload, cell: cellPayload, world_uuid: worldUuid }),
  };

  const submitResult = await apiRequest({
    url: `/searchers.json`,
    options: requestOptions,
  });

  if (submitResult.redirect_path) {
    window.location = submitResult.redirect_path;
  } else {
    submitResult.errors.forEach((error: string) => console.log(error));
  }
};
