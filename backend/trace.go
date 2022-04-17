package main

import (
	"context"
	"os"

	"go.opentelemetry.io/contrib/propagators/b3"
	"go.opentelemetry.io/otel"
	"go.opentelemetry.io/otel/exporters/otlp/otlptrace"
	"go.opentelemetry.io/otel/exporters/otlp/otlptrace/otlptracehttp"
	stdout "go.opentelemetry.io/otel/exporters/stdout/stdouttrace"
	"go.opentelemetry.io/otel/propagation"
	sdktrace "go.opentelemetry.io/otel/sdk/trace"
	"go.uber.org/zap"
)

func installExportPipeline(ctx context.Context, logger *zap.Logger) func() {
	var (
		exporter sdktrace.SpanExporter
		err      error
	)

	if os.Getenv("OTEL_EXPORTER_OTLP_TRACES_ENDPOINT") != "" {
		client := otlptracehttp.NewClient()
		exporter, err = otlptrace.New(ctx, client)

		if err != nil {
			logger.Fatal("Fatal create an OTLP trace exporter", zap.Error(err))
		}
	} else {
		exporter, err = stdout.New()
		if err != nil {
			logger.Fatal("Fatal create an stdout tracer exporter", zap.Error(err))
		}
	}

	tp := sdktrace.NewTracerProvider(
		sdktrace.WithSampler(sdktrace.AlwaysSample()),
		sdktrace.WithBatcher(exporter),
	)
	otel.SetTracerProvider(tp)
	otel.SetTextMapPropagator(propagation.NewCompositeTextMapPropagator(
		propagation.TraceContext{},
		propagation.Baggage{},
		b3.New(),
	))

	return func() {
		if err := tp.Shutdown(ctx); err != nil {
			logger.Error("Error shutting down tracer provider", zap.Error(err))
		}
	}
}
