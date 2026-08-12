package ai.runapi.seedream;

import ai.runapi.core.BaseClient;
import ai.runapi.core.ClientOptions;
import ai.runapi.core.http.HttpTransport;
import java.net.URI;
import ai.runapi.seedream.resources.EditImageResource;
import ai.runapi.seedream.resources.DecomposeLayersResource;
import ai.runapi.seedream.resources.TextToImageResource;

/** Seedream model-family Java SDK client. */
public final class SeedreamClient extends BaseClient {
  private final EditImageResource editImage;
  private final DecomposeLayersResource decomposeLayers;
  private final TextToImageResource textToImage;

  private SeedreamClient(ClientOptions options) {
    super(options);
    this.editImage = new EditImageResource(transport(), options());
    this.decomposeLayers = new DecomposeLayersResource(transport(), options());
    this.textToImage = new TextToImageResource(transport(), options());
  }

  /** Creates a new SeedreamClient builder. */
  public static Builder builder() {
    return new Builder();
  }

  /** Edit Image operations. */
  public EditImageResource editImage() {
    return editImage;
  }

  /** Layer decomposition operations. */
  public DecomposeLayersResource decomposeLayers() {
    return decomposeLayers;
  }

  /** Text To Image operations. */
  public TextToImageResource textToImage() {
    return textToImage;
  }

  /** Builder for {@link SeedreamClient}. */
  public static final class Builder extends BaseClient.Builder<Builder> {
    private Builder() {}

    /** Sets the API key. If omitted, the SDK reads {@code RUNAPI_API_KEY}. */
    @Override
    public Builder apiKey(String value) {
      return super.apiKey(value);
    }

    /** Sets the RunAPI base URL. If omitted, the SDK reads {@code RUNAPI_BASE_URL}. */
    @Override
    public Builder baseUrl(String value) {
      return super.baseUrl(value);
    }

    /** Sets the RunAPI base URL from a URI. */
    @Override
    public Builder baseUrl(URI value) {
      return super.baseUrl(value);
    }

    /** Sets a custom HTTP transport. User-provided transports are not closed by SDK clients. */
    @Override
    public Builder transport(HttpTransport value) {
      return super.transport(value);
    }

    /** Builds an immutable SeedreamClient. */
    @Override
    public SeedreamClient build() {
      return new SeedreamClient(options.build());
    }
  }
}
