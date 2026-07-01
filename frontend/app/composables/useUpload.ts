import type { ApolloClient } from '@apollo/client/core'
import { GET_UPLOAD_SIGNATURE } from '~/graphql/admin'

interface UploadSignature {
  signature: string
  timestamp: number
  api_key: string
  cloud_name: string
  folder: string
}


export const useUpload = () => {
  const authCookie = useCookie('auth_token')

  const uploadImage = async (file: File, client: ApolloClient<any>): Promise<string> => {
    const { data } = await client.mutate({
      mutation: GET_UPLOAD_SIGNATURE,
      context: { headers: { Authorization: `Bearer ${authCookie.value}` } }
    })

    const sig: UploadSignature | undefined = data?.get_upload_signature
    if (!sig) throw new Error('Could not obtain an upload signature.')

    const formData = new FormData()
    formData.append('file', file)
    formData.append('api_key', sig.api_key)
    formData.append('timestamp', String(sig.timestamp))
    formData.append('signature', sig.signature)
    formData.append('folder', sig.folder)

    const res = await fetch(
      `https://api.cloudinary.com/v1_1/${sig.cloud_name}/image/upload`,
      { method: 'POST', body: formData }
    )

    if (!res.ok) throw new Error('Image upload failed.')

    const json = await res.json()
    if (!json.secure_url) throw new Error('Image upload failed.')

    return json.secure_url as string
  }

  return { uploadImage }
}
