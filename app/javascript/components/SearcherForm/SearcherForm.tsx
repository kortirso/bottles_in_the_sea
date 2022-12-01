import React, { useEffect, useState } from 'react';

import { Modal } from 'components/atoms';

import { submitFormRequest } from './requests/submitFormRequest';

interface SearcherFormProps  {
  mapPoint: boolean;
  worldUuid: string;
  onClose: () => void;
}

export const SearcherForm = ({ mapPoint, worldUuid, onClose }: SearcherFormProps): JSX.Element => {

  return (
    <Modal show={!!mapPoint}>
      <div className="button small modal-close" onClick={onClose}>
        X
      </div>
      <div className="modal-header">
        <h2>Searcher Form</h2>
        <p>Selected hex - {mapPoint.column}-{mapPoint.row}</p>
      </div>
      <div id="submit-button">
        <button className="button" onClick={() => submitFormRequest(mapPoint, worldUuid)}>
          Save
        </button>
      </div>
    </Modal>
  );
};
