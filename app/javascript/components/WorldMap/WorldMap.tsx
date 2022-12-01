import React, { useEffect, useState } from 'react';

import { hexagons } from 'data';
import { BottleForm, SearcherForm } from 'components';

const GROUND_COLOR = '#4ade80';
const WATER_COLOR = '#38bdf8';

interface WorldMapProps  {
  userLogged: boolean;
  worldUuid: string;
}

export const WorldMap = ({ userLogged, worldUuid }: WorldMapProps): JSX.Element => {
  const [mapPoint, setMapPoint] = useState();

  const drawWorldCells = () => {
    const canvas = document.getElementById('world-map-canvas');
    const ctx = canvas.getContext('2d');

    // render hexagons on the map
    hexagons.forEach(hexagon => {
      let path = new Path2D(hexagon.svg_path);
      ctx.fillStyle = hexagon.surface === 'ground' ? GROUND_COLOR : WATER_COLOR;
      ctx.strokeStyle = '#fff';
      ctx.fill(path);
      ctx.stroke(path);
    });

    const isIntersect = (point, hexagon) => {
      return Math.sqrt((point.x - hexagon.center_x) ** 2 + (point.y - hexagon.center_y) ** 2) < 17.3;
    };

    // do not add event listeners for unlogged users
    if (!userLogged) return null;

    // catch hexagons clicks
    canvas.addEventListener('click', (e) => {
      const pos = { x: e.offsetX, y: e.offsetY };
      hexagons.find(hexagon => {
        if (isIntersect(pos, hexagon)) setMapPoint(hexagon)
      });
    });
  };

  useEffect(() => {
    drawWorldCells();
  }, []);

  const renderForm = () => {
    if (!userLogged) return <h2>First you need to login to have opportunity to throw bottles</h2>
    return <h2>Select hex</h2>;
  };

  return (
    <>
      {renderForm()}
      <div id="world-map-wrapper">
        <canvas id="world-map-canvas" width="1440" height="550"></canvas>
      </div>
      {userLogged && mapPoint?.surface === 'water' ? (
        <BottleForm
          mapPoint={mapPoint}
          worldUuid={worldUuid}
          onClose={() => setMapPoint(undefined)}
        />
      ) : null}
      {userLogged && mapPoint?.surface === 'ground' ? (
        <SearcherForm
          mapPoint={mapPoint}
          worldUuid={worldUuid}
          onClose={() => setMapPoint(undefined)}
        />
      ) : null}
    </>
  );
};
