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

  const drawWorldCells = () => {
    const canvas = document.getElementById('world-map-canvas');
    const ctx = canvas.getContext('2d');

    const a = 2 * Math.PI / 6;
    const r = 25;

    let currentGroundIndex = 0;
    const drawGrid = (cols, rows) => {
      for (let y = r, i = 0; i < rows; y += r * Math.sin(a), i++) {
        for (let x = r, j = 0; j < cols; x += r * (1 + Math.cos(a)), y += (-1) ** j++ * r * Math.sin(a)) {
          let currentGround = grounds[currentGroundIndex];
          if (currentGround?.q === j && currentGround?.r === i) {
            currentGroundIndex += 1;
            drawHexagon(x, y, true);
          } else {
            drawHexagon(x, y, false);
          }
        }
      }
    }

    function drawHexagon(x, y, isGround) {
      ctx.beginPath();
      for (var i = 0; i < 6; i++) {
        ctx.lineTo(x + r * Math.cos(a * i), y + r * Math.sin(a * i));
      }
      ctx.fillStyle = isGround ? '#4ade80' : '#38bdf8';
      ctx.strokeStyle = '#fff';
      ctx.fill();
      ctx.closePath();
      ctx.stroke();
    }

    drawGrid(mapSize.q + 1, mapSize.r + 1);
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
    <canvas id="world-map-canvas" width="1024" height="550"></canvas>
  );
};
