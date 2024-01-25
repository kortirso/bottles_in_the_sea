import { csrfToken } from '../../../helpers';
import { apiRequest } from '../../../requests/helpers/apiRequest';

export const submitFormRequest = async (mapPoint, worldUuid, bottleForm, bottleFile) => {
  if (!bottleForm) return; // TODO: add errors rendering
  if (!bottleFile) return; // TODO: add errors rendering

  const formData = new FormData();
  formData.append('bottle[files][]', bottleFile);
  formData.append('bottle[form]', bottleForm);
  formData.append('cell[column]', mapPoint.column);
  formData.append('cell[row]', mapPoint.row);
  formData.append('world_uuid', worldUuid)

  const requestOptions = {
    method: 'POST',
    headers: { 'X-CSRF-TOKEN': csrfToken() },
    body: formData
  };

  const submitResult = await apiRequest({
    url: '/bottles.json',
    options: requestOptions
  });

  if (submitResult.redirect_path) {
    window.location = submitResult.redirect_path;
  } else {
    submitResult.errors.forEach((error) => console.log(error));
  }
};
