{{- define "factorio.name" -}}
{{- .Chart.Name | trunc 63 | trimSuffix "-" -}}
{{- end }}

{{- define "factorio.fullname" -}}
{{- printf "%s" (include "factorio.name" .) -}}
{{- end }}

{{- define "factorio.labels" -}}
app.kubernetes.io/name: {{ include "factorio.name" . }}
app.kubernetes.io/instance: {{ include "factorio.fullname" . }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "factorio.selectorLabels" -}}
app: {{ include "factorio.name" . }}
{{- end }}
