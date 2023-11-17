{{/*
Expand the name of the chart.
*/}}
{{- define "chart-external-configuration-file.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "chart-external-configuration-file.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "chart-external-configuration-file.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "chart-external-configuration-file.labels" -}}
helm.sh/chart: {{ include "chart-external-configuration-file.chart" . }}
{{ include "chart-external-configuration-file.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "chart-external-configuration-file.selectorLabels" -}}
app.kubernetes.io/name: {{ include "chart-external-configuration-file.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "chart-external-configuration-file.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "chart-external-configuration-file.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "testReplicaCount" -}}
{{- if eq .Values.profile "test" }}
{{- $flavorTest := .Files.Get "flavor/flavor-test.yaml" | fromYaml  }}
{{- $flavorTest.test.replicaCount }}
{{- else if eq .Values.profile "pre" }}
{{- $flavorPre := .Files.Get "flavor/flavor-pre.yaml" | fromYaml  }}
{{- $flavorPre.test.replicaCount }}
{{- else if eq .Values.profile "prod" }}
{{- $flavorProd := .Files.Get "flavor/flavor-prod.yaml" | fromYaml  }}
{{- $flavorProd.test.replicaCount }}
{{- else }}
{{- .Values.test.replicaCount }}
{{- end }}
{{- end }}

{{- define "testResources" -}}
{{- if eq .Values.profile "test" }}
{{- $flavorTest := .Files.Get "flavor/flavor-test.yaml" | fromYaml  }}
{{- toYaml $flavorTest.test.resources | nindent 12 }}
{{- else if eq .Values.profile "pre" }}
{{- $flavorPre := .Files.Get "flavor/flavor-pre.yaml" | fromYaml  }}
{{- toYaml $flavorPre.test.resources | nindent 12 }}
{{- else if eq .Values.profile "prod" }}
{{- $flavorProd := .Files.Get "flavor/flavor-prod.yaml" | fromYaml  }}
{{- toYaml $flavorProd.test.resources | nindent 12 }}
{{- else }}
{{- toYaml .Values.resources | nindent 12 }}
{{- end }}
{{- end }}

