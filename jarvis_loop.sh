#!/bin/bash
while true; do
  python3 jarvis_brain.py
  echo "Esperando 60s antes de re-chequear..."
  sleep 60
done
