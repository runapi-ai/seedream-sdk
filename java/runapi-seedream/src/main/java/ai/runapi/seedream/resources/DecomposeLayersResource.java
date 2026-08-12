package ai.runapi.seedream.resources;

import ai.runapi.core.ClientOptions;
import ai.runapi.core.RequestOptions;
import ai.runapi.core.http.HttpTransport;
import ai.runapi.core.polling.TaskCreateResponse;
import ai.runapi.seedream.types.CompletedDecomposeLayersResponse;
import ai.runapi.seedream.types.DecomposeLayersParams;
import ai.runapi.seedream.types.DecomposeLayersResponse;

/** Layer decomposition operations. */
public final class DecomposeLayersResource extends SeedreamResource {
  /** API endpoint path for layer decomposition operations. */
  public static final String ENDPOINT = "/api/v1/seedream/decompose_layers";

  /** Creates a resource bound to the supplied transport and client options. */
  public DecomposeLayersResource(HttpTransport transport, ClientOptions options) {
    super(transport, options, ENDPOINT);
  }

  /** Creates a layer decomposition task. */
  public TaskCreateResponse create(DecomposeLayersParams params) {
    return create(params, RequestOptions.none());
  }

  /** Creates a layer decomposition task with per-request options. */
  public TaskCreateResponse create(DecomposeLayersParams params, RequestOptions options) {
    return createTask(params.action(), params.toMap(), options);
  }

  /** Retrieves a layer decomposition task by ID. */
  public DecomposeLayersResponse get(String id) {
    return get(id, RequestOptions.none());
  }

  /** Retrieves a layer decomposition task by ID with per-request options. */
  public DecomposeLayersResponse get(String id, RequestOptions options) {
    return getTask(id, options, DecomposeLayersResponse.class);
  }

  /** Creates a layer decomposition task and polls until it completes. */
  public CompletedDecomposeLayersResponse run(DecomposeLayersParams params) {
    return run(params, RequestOptions.none());
  }

  /** Creates a layer decomposition task and polls with per-request options. */
  public CompletedDecomposeLayersResponse run(DecomposeLayersParams params, RequestOptions options) {
    return runTask(
        params.action(), params.toMap(), options,
        DecomposeLayersResponse.class, CompletedDecomposeLayersResponse.class);
  }
}
