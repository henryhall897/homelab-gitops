{{/*
Traefik Pod Template
This defines the Pod spec injected under spec.template in the Deployment.
Compliant with Kyverno restricted pod policies.
*/}}
{{- define "traefik.podTemplate" -}}
template:
  metadata:
    annotations:
    {{- if .Values.deployment.podAnnotations }}
{{ tpl (toYaml .Values.deployment.podAnnotations) . | indent 6 }}
    {{- end }}
    {{- if .Values.metrics }}
    {{- if and (.Values.metrics.prometheus) (not (.Values.metrics.prometheus.serviceMonitor).enabled) }}
      prometheus.io/scrape: "true"
      prometheus.io/path: "/metrics"
      prometheus.io/port: {{ quote (index .Values.ports .Values.metrics.prometheus.entryPoint).port }}
    {{- end }}
    {{- end }}
    labels:
      {{- include "traefik.labels" . | nindent 6 }}
      app.kubernetes.io/component: traefik
      app.kubernetes.io/instance: {{ .Release.Name }}
    {{- if .Values.global.azure.enabled }}
      azure-extensions-usage-release-identifier: {{ .Release.Name }}
    {{- end }}
  spec:
    serviceAccountName: {{ include "traefik.serviceAccountName" . }}
    automountServiceAccountToken: true
    terminationGracePeriodSeconds: {{ default 60 .Values.deployment.terminationGracePeriodSeconds }}
    hostNetwork: {{ .Values.hostNetwork }}
    {{- with .Values.podSecurityContext }}
    securityContext:
{{ toYaml . | indent 6 }}
    {{- end }}

    containers:
      - name: traefik
        image: "{{ .Values.image.registry }}/{{ .Values.image.repository }}:{{ .Values.image.tag }}"
        imagePullPolicy: {{ .Values.image.pullPolicy }}
        args:
          {{- with .Values.deployment.additionalArguments }}
          {{- toYaml . | nindent 10 }}
          {{- end }}


        ports:
          - name: web
            containerPort: {{ .Values.ports.web.port }}
            protocol: TCP
          - name: websecure
            containerPort: {{ .Values.ports.websecure.port }}
            protocol: TCP
        readinessProbe:
          httpGet:
            path: /ping
            port: {{ .Values.deployment.healthchecksPort | default 8000 }}
          initialDelaySeconds: 3
          periodSeconds: 5
        livenessProbe:
          httpGet:
            path: /ping
            port: {{ .Values.deployment.healthchecksPort | default 8000 }}
          initialDelaySeconds: 5
          periodSeconds: 10
        {{- with .Values.securityContext }}
        securityContext:
{{ toYaml . | indent 10 }}
        {{- end }}
        {{- with .Values.resources }}
        resources:
{{ toYaml . | indent 10 }}
        {{- end }}
        volumeMounts:
          - name: tmp
            mountPath: /tmp
          - name: config
            mountPath: /etc/traefik
            readOnly: true

    volumes:
      - name: tmp
        emptyDir: {}
      - name: config
        emptyDir: {}

    {{- with .Values.nodeSelector }}
    nodeSelector:
{{ toYaml . | indent 6 }}
    {{- end }}
    {{- with .Values.tolerations }}
    tolerations:
{{ toYaml . | indent 6 }}
    {{- end }}
    {{- with .Values.affinity }}
    affinity:
{{ toYaml . | indent 6 }}
    {{- end }}
{{- end -}}
