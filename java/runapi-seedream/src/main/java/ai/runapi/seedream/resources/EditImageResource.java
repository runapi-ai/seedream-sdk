package ai.runapi.seedream.resources;

import ai.runapi.core.ClientOptions;
import ai.runapi.core.RequestOptions;
import ai.runapi.core.http.HttpTransport;
import ai.runapi.core.polling.TaskCreateResponse;
import ai.runapi.seedream.types.CompletedEditImageResponse;
import ai.runapi.seedream.types.EditImageParams;
import ai.runapi.seedream.types.EditImageResponse;

/** Edit Image operations. */
public final class EditImageResource extends SeedreamResource {
  /** API endpoint path for edit image operations. */
  public static final String ENDPOINT = "/api/v1/seedream/edit_image";

  /** Creates a resource bound to the supplied transport and client options. */
  public EditImageResource(HttpTransport transport, ClientOptions options) {
    super(transport, options, ENDPOINT);
  }

  /** Creates a edit image task. */
  public TaskCreateResponse create(EditImageParams params) {
    return create(params, RequestOptions.none());
  }

  /** Creates a edit image task with per-request options. */
  public TaskCreateResponse create(EditImageParams params, RequestOptions options) {
    return createTask(params.action(), params.toMap(), options);
  }

  /** Retrieves a edit image task by ID. */
  public EditImageResponse get(String id) {
    return get(id, RequestOptions.none());
  }

  /** Retrieves a edit image task by ID with per-request options. */
  public EditImageResponse get(String id, RequestOptions options) {
    return getTask(id, options, EditImageResponse.class);
  }

  /** Creates a edit image task and polls until it completes. */
  public CompletedEditImageResponse run(EditImageParams params) {
    return run(params, RequestOptions.none());
  }

  /** Creates a edit image task with per-request options and polls until it completes. */
  public CompletedEditImageResponse run(EditImageParams params, RequestOptions options) {
    return runTask(params.action(), params.toMap(), options, EditImageResponse.class, CompletedEditImageResponse.class);
  }
}
