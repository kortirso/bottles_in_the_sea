import { csrfToken } from 'helpers';
import { apiRequest } from 'requests/helpers/apiRequest';

export const submitFormRequest = async (mapPoint, worldUuid: string) => {
  const bottlePayload = {
    form: 'bordeaux'
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
    body: JSON.stringify({ bottle: bottlePayload, cell: cellPayload, world_uuid: worldUuid }),
  };

  const submitResult = await apiRequest({
    url: `/bottles.json`,
    options: requestOptions,
  });

  if (submitResult.redirect_path) {
    window.location = submitResult.redirect_path;
  } else {
    submitResult.errors.forEach((error: string) => console.log(error));
  }
};
