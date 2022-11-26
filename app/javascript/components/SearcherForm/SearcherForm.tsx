import React, { useEffect, useState } from 'react';

import { Modal } from 'components/atoms';

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
      </div>
    </Modal>
  );
};
