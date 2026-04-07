import { BuilderNameConstants } from '@ohos/customrouter'

export { carbonCircle_homePage } from './src/main/ets/pages/CarbonCircle_homePage'

export async function harInit(builderName: string): Promise<void> {
  switch (builderName) {
    case BuilderNameConstants.HAR_carboncircle_msgEditingPage:
      await import("./src//main//ets//pages//MsgEditPage")
      break
    case BuilderNameConstants.HAR_carboncircle_comment:
      await import("./src//main//ets//pages//CommentsPage")
      break
    case BuilderNameConstants.HAR_carboncircle_innerComment:
      await import("./src//main//ets//pages//InnerCommentPage")
      break
    default:
      break
  }
}