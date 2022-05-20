#!/bin/sh
set -o xtrace

#enable usage metrics and set retention 12 months
vault write sys/internal/counters/config enabled=enable retention_months=12