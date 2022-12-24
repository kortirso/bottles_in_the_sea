import React, { useEffect, useState } from 'react';

import { currentLocale, localizeValue } from 'helpers';
import { strings } from 'locales';

import { Dropdown, Modal } from 'components/atoms';

import { submitFormRequest } from './requests/submitFormRequest';
import { bottleFormsRequest } from './requests/bottleFormsRequest';

interface BottleFormProps  {
  mapPoint: boolean;
  worldUuid: string;
  onClose: () => void;
}

const BOTTLE_FORMS = {
  'bordeaux': { en: 'Bordeaux', ru: 'Бордо' },
  'burgundy': { en: 'Burgundy', ru: 'Бургундская' }
};

export const BottleForm = ({ mapPoint, worldUuid, onClose }: BottleFormProps): JSX.Element => {
  const [bottleForms, setBottleForms] = useState([]);
  const [bottleForm, setBottleForm] = useState<string>();
  const [bottleFile, setBottleFile] = useState();

  useEffect(() => {
    const fetchBottleForms = async () => {
      const data = await bottleFormsRequest(worldUuid);
      setBottleForms(data);
    };

    strings.setLanguage(currentLocale);
    fetchBottleForms();
  }, []); // eslint-disable-line react-hooks/exhaustive-deps

  return (
    <Modal show={!!mapPoint}>
      <div className="button small modal-close" onClick={onClose}>
        X
      </div>
      <div className="modal-header">
        <h2>{strings.bottleForm.title}</h2>
      </div>
      <Dropdown
        title={strings.bottleForm.bottleFormsDropdown}
        items={bottleForms.reduce((obj, key) => ({ ...obj, [key]: localizeValue(BOTTLE_FORMS[key]) }), {})}
        placeholder={strings.bottleForm.selectPlaceholder}
        onSelect={(value) => setBottleForm(value)}
        selectedItem={bottleForm}
      />
      <div className='form-field'>
        <label htmlFor='bottle-file' className='file-uploader'>{strings.bottleForm.attach}</label>
        {bottleFile ? (
          <span className='file-name'>{bottleFile.name}</span>
        ) : null}
        <input
          type='file'
          className='form-control-file'
          id='bottle-file'
          onChange={(event) => setBottleFile(event.target.files[0])}
        />
      </div>
      <div id="submit-button">
        <button className="button" onClick={() => submitFormRequest(mapPoint, worldUuid, bottleForm, bottleFile)}>
          {strings.bottleForm.save}
        </button>
      </div>
    </Modal>
  );
};
