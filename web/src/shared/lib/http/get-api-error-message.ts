import axios from 'axios'

export function getApiErrorMessage(error: unknown) {
  if (axios.isAxiosError(error)) {
    const responseData = error.response?.data
    const message =
      typeof responseData === 'object' &&
      responseData !== null &&
      'message' in responseData
        ? responseData.message
        : undefined

    if (typeof message === 'string' && message.trim().length > 0) {
      return message
    }

    if (error.code === 'ECONNABORTED') {
      return 'Request timeout. Please try again.'
    }

    if (!error.response) {
      return 'Unable to connect to the server.'
    }
  }

  if (error instanceof Error && error.message.trim().length > 0) {
    return error.message
  }

  return 'Something went wrong. Please try again.'
}
