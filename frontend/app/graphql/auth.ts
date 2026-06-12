export const SIGNUP_MUTATION = gql`
  mutation Signup($full_name: String!, $email: String!, $password: String!) {
    signup(full_name: $full_name, email: $email, password: $password) {
      id
      full_name
      email
    }
  }
`;

export const LOGIN_MUTATION = gql`
  mutation Login($email: String!, $password: String!) {
    login(email: $email, password: $password) {
      token
      id
      full_name
    }
  }
`;
