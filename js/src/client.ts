import { createHttpClient, type ClientOptions } from '@runapi.ai/core';
import { TextToImage } from './resources/text-to-image';
import { EditImage } from './resources/edit-image';

export class SeedreamClient {
  public readonly textToImage: TextToImage;
  public readonly editImage: EditImage;

  constructor(options: ClientOptions = {}) {
    const http = createHttpClient(options);
    this.textToImage = new TextToImage(http);
    this.editImage = new EditImage(http);
  }
}
