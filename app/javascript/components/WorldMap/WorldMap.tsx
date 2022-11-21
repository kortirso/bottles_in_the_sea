import React, { useEffect, useState } from 'react';

import { worldCellsRequest } from './requests/worldCellsRequest';

interface WorldMapProps {
  worldUuid: string;
  mapSize: {
    q: number;
    r: number;
  };
}

export const WorldMap = ({ worldUuid, mapSize }: WorldMapProps): JSX.Element => {
  const [grounds, setGrounds] = useState([]);
  const [mapPoint, setMapPoint] = useState();

  const range = (start, end) => {
    const length = end - start;
    return Array.from({ length }, (_, i) => start + i);
  }

  const drawWorldCells = () => {
    const canvas = document.getElementById('world-map-canvas');
    const ctx = canvas.getContext('2d');

    // TODO: create hexagons generator to avoid calculations
    const generateHexagons = (cols, rows) => {
      const list = [];
      [...range(0, rows)].forEach((i) => {
        [...range(0, cols)].forEach((j) => {
          const columnCoefficient = j * 30;
          const evenColumn = j % 2 === 0;

          list.push({
            row: i,
            column: j,
            start: columnCoefficient,
            end: evenColumn ? Math.round(i * 34.6) : Math.round(i * 34.6 + 17.3),
            centerX: columnCoefficient + 20,
            centerY: evenColumn ? Math.round(i * 34.6 + 17.3) : Math.round(i * 34.6 + 34.6)
          });
        })
      })
      return list;
    }

    const hexagons = generateHexagons(mapSize.q + 1, mapSize.r + 1);

    let currentGroundIndex = 0;
    let currentGround = grounds[currentGroundIndex];

    hexagons.forEach(hexagon => {
      let p = new Path2D(`M${hexagon.start + 10} ${hexagon.end} ${hexagon.start} ${hexagon.end + 17.3} ${hexagon.start + 10} ${hexagon.end + 34.6} ${hexagon.start + 30} ${hexagon.end + 34.6} ${hexagon.start + 40} ${hexagon.end + 17.3} ${hexagon.start + 30} ${hexagon.end} Z`);
      const isGround = currentGround?.q === hexagon.column && currentGround?.r === hexagon.row
      if (isGround) {
        currentGroundIndex += 1;
        currentGround = grounds[currentGroundIndex];
      }
      ctx.fillStyle = isGround ? '#4ade80' : '#38bdf8';
      ctx.strokeStyle = '#fff';
      ctx.fill(p);
      ctx.stroke(p);
    });

    const isIntersect = (point, hexagon) => {
      return Math.sqrt((point.x - hexagon.centerX) ** 2 + (point.y - hexagon.centerY) ** 2) < 17.3;
    };

    canvas.addEventListener('click', (e) => {
      const pos = { x: e.offsetX, y: e.offsetY };
      hexagons.find(hexagon => {
        if (isIntersect(pos, hexagon)) setMapPoint([hexagon.column, hexagon.row])
      });
    });
  };

  useEffect(() => {
    const fetchWorldCells = async () => {
      const data = await worldCellsRequest(worldUuid);
      setGrounds(data);
    };

    fetchWorldCells();
  }, [worldUuid]);

  useEffect(() => {
    if (grounds.length > 0) drawWorldCells();
  }, [grounds]);

  return (
    <>
      <div id="world-map-wrapper">
        <canvas id="world-map-canvas" width="1024" height="550"></canvas>
      </div>
      <div id="world-map-forms">
        {mapPoint ? (
          <h2>Selected hex - {mapPoint[0]}-{mapPoint[1]}</h2>
        ) : (
          <h2>Select hex</h2>
        )}
      </div>
    </>
  );
};
